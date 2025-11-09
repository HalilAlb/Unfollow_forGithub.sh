# Unfollow_forGithub.sh
🧹 GitHub Unfollow Assistant

A simple Python tool that helps you find and unfollow users who don’t follow you back on GitHub.
Runs in a continuous interactive loop until you choose to quit — safe, simple, and effective.

🚀 Features

Lists all users you follow who don’t follow you back.

Option to unfollow all or specific users by number.

Safe: asks for confirmation before every unfollow.

Auto-refreshes lists after each action.

Keeps running until you select Quit.

Handles invalid input or Ctrl + C gracefully — no crashes.

⚙️ Requirements

Python 3.7+

Internet connection

A GitHub Personal Access Token (PAT) with user:follow permission

🔑 Creating a GitHub Personal Access Token

Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)

Click “Generate new token” → “Generate new token (classic)”

Give it a name like unfollow-script

Under scopes, check only:

user:follow


Scroll down and click “Generate token”

Copy the token (it will look like this):

ghp_AbC123xyz...


⚠️ Keep it private! Never share or upload it anywhere.

💻 Installation

Clone this repository and navigate into it:

git clone https://github.com/HalilAlb/Unfollow_forGithub.sh

cd Unfollow_forGithub.sh


🧠 Usage:

Run the script:

python3 fl.sh


Then follow the prompts:

GitHub - Unfollow users who don't follow you back (loop mode)

GitHub username:
Personal Access Token (needs user:follow scope): ghp_AbC123...

============================================================
You follow 120 users. 89 follow you back.
Users who don't follow you back: 31
1. userA
2. userB
3. userC
...

Options:
1) Unfollow all users who don't follow you back
2) Unfollow a specific user by number
3) Refresh lists
4) Quit (finish process)
Choose an option (1/2/3/4):

🔸 Option Details
Option	Description
1	Unfollows everyone who doesn’t follow you back (asks for confirmation)
2	Lets you enter a number (e.g., 2) to unfollow that specific user
3	Refreshes your followers/following list without unfollowing anyone
4	Safely exits the program
🧩 Notes

The script uses the official GitHub REST API (https://api.github.com).

Your token is never stored — it’s only used in memory while the program runs.

The program respects GitHub’s rate limits (adds short pauses between requests).

If you revoke your token in GitHub settings, it immediately becomes invalid.

⚠️ Disclaimer

This tool interacts with your GitHub account through its public API.
Use it responsibly — avoid excessive unfollow actions in a short period to prevent hitting rate limits or triggering abuse protection.

🧑‍💻 Author

Created by HalilAlb
 — feel free to fork, improve, and contribute!
