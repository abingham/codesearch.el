===============
 codesearch.el
===============

This extension allows you to use the *codesearch* code indexing
system in emacs.

For more details, see the
[project page](https://github.com/abingham/codesearch.el).

For more details on codesearch, see its
[project page](https://github.com/google/codesearch).

Installation
============

The easy way to install `codesearch` is using the emacs package
system. Just search [*melpa*](https://melpa.org/) for "codesearch".

Or you can do it manually. Copy codesearch.el to some location in your
emacs load path. Then add `(require 'codesearch)` to your emacs
initialization (.emacs, init.el, or something).

Example config:

```elisp
(require 'codesearch)
```

Quickstart
==========

You need to add files to the index with `codesearch-build-index` (or
you can do this outside of emacs with `cindex`, of course.) Then
search for what you want in your index:

```elisp
;; First import the package.
(require 'codesearch)

;; Index all of the code in your project.
(codesearch-build-index "/path/to/project")

;; Look for instances of llama jousting in your haskell source
;; files (as one does.) This will display the results as in a new
;; window. You can click the results to go to the matches.
(codesearch-search "Llama.*jousting" "*.hs")
```

More commonly, you want to bind `codesearch-search` to some useful
keybinding, like `M-.`:

```elisp
(global-set-key "\M-." 'codesearch-search)
```

There's more to codesearch, but not much. Just scan the source to see
what else it can do.
