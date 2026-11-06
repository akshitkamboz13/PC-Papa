#!/usr/bin/env python3
"""
Sync all GitHub repositories for user 'akshitkamboz13' to:
1. Laptop GitLab  (git@gitlab-laptop:akshitkamboz13/<repo>.git)
2. Server GitLab  (git@gitlab-server:akshitkamboz13/<repo>.git)
"""

import json
import os
import shutil
import subprocess
import sys
import tempfile
import time

GITHUB_USER = "akshitkamboz13"
LAPTOP_SSH_PREFIX = f"git@gitlab-laptop:{GITHUB_USER}"
SERVER_SSH_PREFIX = f"git@gitlab-server:{GITHUB_USER}"

def run_cmd(cmd, cwd=None, check=True):
    res = subprocess.run(cmd, cwd=cwd, shell=isinstance(cmd, str), capture_output=True, text=True)
    if check and res.returncode != 0:
        raise RuntimeError(f"Command failed [{res.returncode}]: {res.stderr.strip()}")
    return res

def fetch_github_repos():
    print(f"🔍 Fetching repository list for GitHub user @{GITHUB_USER}...")
    res = run_cmd(f"gh repo list {GITHUB_USER} --limit 200 --json name,isPrivate,defaultBranchRef")
    repos = json.loads(res.stdout)
    print(f"📦 Found {len(repos)} repositories on GitHub.")
    return repos

def sync_repo(repo_info, index, total):
    repo_name = repo_info["name"]
    is_private = repo_info.get("isPrivate", False)
    default_branch = repo_info.get("defaultBranchRef", {}).get("name", "")
    
    print(f"\n[{index}/{total}] 🚀 Syncing: {repo_name} ({'Private' if is_private else 'Public'})...")

    # If repo has no default branch, it is empty
    if not default_branch:
        print(f"   ℹ️ Repository '{repo_name}' is empty on GitHub. Initializing empty mirror...")
        temp_dir = tempfile.mkdtemp(prefix=f"sync-{repo_name}-")
        try:
            run_cmd("git init -b main", cwd=temp_dir)
            run_cmd('git commit --allow-empty -m "Initial commit from GitHub empty repo"', cwd=temp_dir)
            # Push to Laptop
            run_cmd(f"git push --set-upstream {LAPTOP_SSH_PREFIX}/{repo_name}.git main", cwd=temp_dir, check=False)
            # Push to Server
            run_cmd(f"git push --set-upstream {SERVER_SSH_PREFIX}/{repo_name}.git main", cwd=temp_dir, check=False)
            print(f"   ✅ Empty project initialized on Laptop and Server GitLab!")
            return True
        except Exception as e:
            print(f"   ⚠️ Error initializing empty repo: {e}")
            return False
        finally:
            shutil.rmtree(temp_dir, ignore_errors=True)

    # Standard non-empty repo: clone mirror and push mirror
    clone_url = f"https://github.com/{GITHUB_USER}/{repo_name}.git"
    temp_mirror = tempfile.mkdtemp(prefix=f"mirror-{repo_name}-")
    mirror_path = os.path.join(temp_mirror, f"{repo_name}.git")
    
    try:
        # Step 1: Bare mirror clone from GitHub
        print(f"   📥 Cloning bare mirror from GitHub...")
        run_cmd(f"git clone --mirror {clone_url} {mirror_path}")

        # Step 2: Push mirror to Laptop GitLab
        print(f"   💻 Replicating to Laptop GitLab (http://localhost:8929)...")
        lap_res = run_cmd(f"git push --mirror {LAPTOP_SSH_PREFIX}/{repo_name}.git", cwd=mirror_path, check=False)
        if lap_res.returncode != 0:
            print(f"   ⚠️ Laptop push notice: {lap_res.stderr.strip()[:100]}")
        else:
            print(f"   ✅ Laptop GitLab mirror synced!")

        # Step 3: Push mirror to Server GitLab
        print(f"   🏰 Replicating to Server GitLab (http://si4k-server.local:8929)...")
        srv_res = run_cmd(f"git push --mirror {SERVER_SSH_PREFIX}/{repo_name}.git", cwd=mirror_path, check=False)
        if srv_res.returncode != 0:
            print(f"   ⚠️ Server push notice: {srv_res.stderr.strip()[:100]}")
        else:
            print(f"   ✅ Server GitLab mirror synced!")

        return True
    except Exception as e:
        print(f"   ❌ Sync failed for {repo_name}: {e}")
        return False
    finally:
        shutil.rmtree(temp_mirror, ignore_errors=True)

def main():
    start_time = time.time()
    repos = fetch_github_repos()
    
    success_count = 0
    fail_count = 0
    
    for i, repo in enumerate(repos, 1):
        if sync_repo(repo, i, len(repos)):
            success_count += 1
        else:
            fail_count += 1

    elapsed = round(time.time() - start_time, 1)
    print("\n" + "=" * 60)
    print(f"🎉 GITHUB TO GITLABS SYNC COMPLETE ({elapsed}s)")
    print(f"✅ Successfully Synced: {success_count}/{len(repos)}")
    if fail_count > 0:
        print(f"⚠️ Failed / Warned:     {fail_count}/{len(repos)}")
    print(f"🌐 Laptop GitLab:  http://localhost:8929/akshitkamboz13")
    print(f"🏰 Server GitLab:  http://si4k-server.local:8929/akshitkamboz13")
    print("=" * 60)

if __name__ == "__main__":
    main()
