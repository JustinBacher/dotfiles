#!/bin/env fish

set data $(keeper get --format=json "SIybz-Gl4FC1qQ9wsG2x1w")
set passphrase (echo $data | jq -r '.custom[] | select(.label == "SSH Passphrase") | .value[0]')
set github_token (echo $data | jq -r '.custom[] | select(.label == "Personal Access Token") | .value[0]')

if test -z "$github_token" -a -z "$passphrase"
    echo "Unable to get login info for github"
    exit 0
end

# Matches IdentityFile in private_dot_ssh/config
set ssh_key_path "$HOME/.ssh/id_github"

# Never overwrite an existing key: ssh-keygen would prompt, and this runs unattended
if test -f "$ssh_key_path"
    echo "SSH key $ssh_key_path already exists; skipping."
    exit 0
end

echo "Generating ssh key for $(hostname)"
ssh-keygen -q -t ed25519 -f $ssh_key_path -N "$passphrase" -C "github@$(hostname)"

# Start the SSH agent and add the new key
ssh-agent
ssh-add $ssh_key_path

# Add public key to GitHub via API
curl -Ls \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $github_token" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/user/keys \
    -d (string join '' '{"title":"' (hostname) '","key":"' (cat $ssh_key_path.pub) '"}')

echo "SSH key added to GitHub successfully"
