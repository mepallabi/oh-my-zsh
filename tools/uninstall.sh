read -r -p "Are you sure you want to remove Oh My Zsh? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

echo "Removing ~/.oh-my-zsh"
if [ -d ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi

CHECK_AUTOJUMP=$(brew list | grep autojump | wc -l)
if [ $CHECK_AUTOJUMP -ge 1 ]; then
  echo "uninstalling autojump"
  brew uninstall autojump
fi
unset CHECK_AUTOJUMP

CHECK_ZSHSH=$(brew list | grep zsh-syntax-highlighting | wc -l)
if [ $CHECK_ZSHSH -ge 1 ]; then
  echo "uninstalling zsh-syntax-highlighting"
  brew uninstall zsh-syntax-highlighting
fi
unset CHECK_ZSHSH

echo "Looking for original zsh config..."
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]; then
  echo "Found ~/.zshrc.pre-oh-my-zsh -- Restoring to ~/.zshrc";

  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    ZSHRC_SAVE=".zshrc.omz-uninstalled-$(date +%Y%m%d%H%M%S)";
    echo "Found ~/.zshrc -- Renaming to ~/${ZSHRC_SAVE}";
    mv ~/.zshrc ~/"${ZSHRC_SAVE}";
  fi

  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc;

  echo "Your original zsh config was restored. Please restart your session."
else
  if hash chsh >/dev/null 2>&1; then
    echo "Switching back to bash"
    chsh -s /bin/bash
  else
    echo "You can edit /etc/passwd to switch your default shell back to bash"
  fi
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
