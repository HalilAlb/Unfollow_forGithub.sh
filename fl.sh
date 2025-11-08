#!/usr/bin/env python3
"""
not_following_back_loop.py

Find users you follow who don't follow you back and let you unfollow them.
Runs in a continuous loop until you choose to quit.

Usage:
    python3 not_following_back_loop.py
"""
import requests
import time

API_BASE = "https://api.github.com"

def get_users(url, headers):
    users = []
    page = 1
    while True:
        resp = requests.get(f"{url}?per_page=100&page={page}", headers=headers)
        if resp.status_code != 200:
            print(f"[ERROR] Failed to fetch: {resp.status_code} - {resp.text}")
            return None
        data = resp.json()
        if not data:
            break
        users.extend([u["login"] for u in data])
        page += 1
    return users

def unfollow_user(target, headers):
    url = f"{API_BASE}/user/following/{target}"
    resp = requests.delete(url, headers=headers)
    if resp.status_code == 204:
        print(f"[OK] Unfollowed: {target}")
        return True
    else:
        print(f"[WARN] Could not unfollow {target} (status {resp.status_code}). Response: {resp.text}")
        return False

def build_not_following(username, headers):
    following = get_users(f"{API_BASE}/users/{username}/following", headers)
    if following is None:
        return None, None, None
    followers = get_users(f"{API_BASE}/users/{username}/followers", headers)
    if followers is None:
        return None, None, None
    not_following_back = [u for u in following if u not in followers]
    return following, followers, not_following_back

def prompt_int(prompt_text):
    s = input(prompt_text).strip()
    try:
        return int(s)
    except ValueError:
        return None

def main():
    print("GitHub - Unfollow users who don't follow you back (loop mode)\n")
    username = input("GitHub username: ").strip()
    token = input("Personal Access Token (needs user:follow scope): ").strip()

    if not username or not token:
        print("Username and token are required. Exiting.")
        return

    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github+json"
    }

    # initial fetch
    result = build_not_following(username, headers)
    if result[0] is None:
        print("Failed to fetch initial lists. Check username/token and network.")
        return
    following, followers, not_following_back = result

    # main loop
    while True:
        try:
            print("\n" + "="*60)
            print(f"You follow {len(following)} users. {len(followers)} follow you back.")
            if not_following_back:
                print(f"Users who don't follow you back: {len(not_following_back)}")
                for i, u in enumerate(not_following_back, start=1):
                    print(f"{i}. {u}")
            else:
                print("✅ Everyone you follow follows you back (no one to unfollow).")

            print("\nOptions:")
            print("1) Unfollow all users who don't follow you back")
            print("2) Unfollow a specific user by number")
            print("3) Refresh lists")
            print("4) Quit (finish process)")

            choice = input("Choose an option (1/2/3/4): ").strip()

            if choice == "1":
                if not not_following_back:
                    print("Nothing to unfollow.")
                    continue
                confirm = input("Are you sure you want to unfollow ALL listed users? (y/n): ").strip().lower()
                if confirm != "y":
                    print("Canceled unfollow all.")
                    continue
                for target in list(not_following_back):  # copy because we'll refresh later
                    unfollow_user(target, headers)
                    # small pause to be polite with API
                    time.sleep(0.5)
                # refresh after action
                following, followers, not_following_back = build_not_following(username, headers)
                if following is None:
                    print("Failed to refresh after unfollowing. Exiting loop.")
                    break

            elif choice == "2":
                if not not_following_back:
                    print("No users to unfollow.")
                    continue
                idx = prompt_int("Enter the number of the user to unfollow (as shown in the list): ")
                if idx is None:
                    print("Invalid input — please type a number. Returning to menu.")
                    continue
                if not (1 <= idx <= len(not_following_back)):
                    print(f"Invalid number. Please choose a number between 1 and {len(not_following_back)}.")
                    continue
                target = not_following_back[idx - 1]
                confirm = input(f"Unfollow {target}? (y/n): ").strip().lower()
                if confirm != "y":
                    print("Canceled unfollow.")
                    continue
                unfollow_user(target, headers)
                # refresh after action
                following, followers, not_following_back = build_not_following(username, headers)
                if following is None:
                    print("Failed to refresh after unfollowing. Exiting loop.")
                    break

            elif choice == "3":
                print("Refreshing lists...")
                following, followers, not_following_back = build_not_following(username, headers)
                if following is None:
                    print("Refresh failed. Check token/username/rate limits.")
                    break
                print("Refreshed.")

            elif choice == "4":
                confirm = input("Are you sure you want to finish the process and quit? (y/n): ").strip().lower()
                if confirm == "y":
                    print("Finished. Goodbye.")
                    break
                else:
                    print("Continue running.")

            else:
                print("Unknown choice. Please select 1, 2, 3 or 4.")

        except KeyboardInterrupt:
            # Ignore Ctrl+C and keep running until the user explicitly chooses Quit
            print("\n[INFO] Keyboard interrupt detected — program will continue. Use option 4 to quit.")
            continue
        except Exception as e:
            print(f"[ERROR] Unexpected error: {e}")
            # decide to continue loop instead of exiting
            time.sleep(1)
            continue

if __name__ == "__main__":
    main()

