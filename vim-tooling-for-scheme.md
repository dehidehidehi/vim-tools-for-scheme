# The Vim tooling for Scheme project

Audience : 
- developpers who want to make programs in Scheme.
- Vim users who don't use Emacs

Not the audience : 
- students who are not making complex programs.
- NeoVim users

# Difficulties observed:

The developper experience for Lisps, and in this case Scheme, is painful.
Setting up a developping environment for Scheme requires a lot of thinking and overhead for the developper who just wants to make a program.

Examples of such overhead include:
- The little tooling which may exist is difficult to discover.
- The tooling which exists requires far too much time to configure.
- Some tooling is specific to the Scheme language.
- Some tooling is specific to the RNRS standard used.

# Solutions 

To address this, the goal is to provide a better developper experience with Vim.

We automatically provide:
- provide sane and overridable LSP configuration defaults for VIM
- a remap for the ']' key to automatically close parenthesis or brackets.
- keybindable vim commands which automatically setup your scheme REPL with library path detection.
- combine the best of both worlds using the RNRS standard and have the Racket LSP and the ChezScheme LSP work nicely together.
- support for documentation pop-ups from within Vim; this is a challenge given the many scheme specifications and the absence of docstrings
- provide sane and overridable Lisp vim settings

# TODO list

## define requirements

- [ ] vim9 build script?

## a new vim rc file to include

- [ ] move all my lisp and scheme config into a separate rc file
- [ ] organize the rc file
- [ ] make sure everything is in augroups and overridable and commented and credited 
- [ ] finalize LSP configuration for Scheme

## scripts to install external tooling

- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...
- [ ] ...


# Back-burner
- [ ] Convert this all into a nicely packaged vim plugin
