#!/bin/bash

set -ex

wget -c https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 -O gitlab-runner-linux-amd64
wget -c https://gitlab-runner-downloads.s3.amazonaws.com/latest/release.sha256 -O release.sha256

sed -i 's;binaries/;./;g' release.sha256
sha256sum --ignore-missing -c release.sha256

chmod +x ./gitlab-runner-linux-amd64

export RUNNER_NAME=$(hostname) RUNNER_EXECUTOR=shell

echo "<html><head><title>CloudFlare Pages - Or: Free CI/CD Runners</title></head><body><p>Full story at: <a href='https://f0o.dev/posts/2021/07/cloudflare-pages-or-free-ci/cd-runners/'>CloudFlare Pages - Or: Free CI/CD Runners</a></p><pre>Start: $(date)</pre><pre>" > null/index.html
{
  ./gitlab-runner-linux-amd64 register -n
  timeout 900 ./gitlab-runner-linux-amd64 run || true
} &>> null/index.html
echo "</pre><pre>End: $(date)</pre></body>" >> null/index.html
