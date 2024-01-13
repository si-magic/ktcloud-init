# KT Cloud Console only supports RSA1024 SSH keys
There's a serious issues regarding KT Cloud Console's SSH key management.

- It does not support importing public SSH keys. You cannot use your own SSH key
- It only generates 1024 bit RSA keys

The issue has been raised with the support team, but they failed to understand
the issue at hand.

On modern distros, 1024-bit RSA keys are not allowed by the system default
crypto policies. Other users might be getting away with it because they use
SSH clients like PuTTY.

My advice is ..

- Block CloudStack's public key insertion by
  - Masking `cloud-set-guest-sshkey.in`
  - Masking `/root/.ssh/authorized_keys`
  - Disabling root SSH login
- Do not process sensitive information on KT Cloud's CloudStack instance
