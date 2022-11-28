# Six Colors Mode - for Emacs users that bleed in six colors 🦄

This software is a homage to the old six colors Apple logo and to what that culture has meant for the community.

It draws a rainbow on the modeline according to the position of the point, so to have a horizontal scrollbar that shows you where the point is relatively to the size of the current buffer.

It's basically a fork of [TeMPOraL Nyan-mode](https://github.com/TeMPOraL/nyan-mode) but without the cat, the animations and the music. 
The rainbow is based on the colors of the six colors rainbow logo that Apple used between 1977 and 1998.

> Apple was 90 days away from going bankrupt back then. 
> Was much worse than I thought when I went back. 
> I actually asked people, ‘Why are you still here?’. 
> And the answer was, ‘Because I bleed in 6 colors.’
>  
> -- Steve Jobs, on his return to Apple


![screenshot](./sixcolors-mode.png)

And if you don't like the six-colors Apple logo, you can easily customizing the appearance by using the `sixcolors-colors` variable by using the standard `M-x configure` command under emacs or by manually set it to a list of colors (up to six obviously).

Some example, for italians users like me:

![italy](./italy.png)

for the americans ones:

![usa](./usa.png)

and if you are a nostalgic spectrum user:

![spectrum](./spectrum.png)


## Installation

This project is available on [MELPA](https://melpa.org/) [![MELPA](https://melpa.org/packages/sixcolors-mode-badge.svg)](https://melpa.org/#/sixcolors-mode) and can be installed using the Emacs package manager.

```
(use-package sixcolors-mode)
(sixcolors-mode)
```

If you want to customize the colors of your bar just set the single colors (up to six) as a list assigned to the `sixcolors-colors` variable.
For example:

```
(setq sixcolors-colors '("#009246" "#009246" "#FFFFFF" "#FFFFFF" "#CE2b37" "#CE2B37"))
```

