# language-do package for Atom

This package adds **language support and syntax highlighting for [Stata](http://stata.com/) .do files** in the Open-Source, next generation [**Atom Text Editor**](https://github.com/atom/atom).

![](http://i.imgur.com/Nnnp4Pr.png)


## How to install it in Atom:
You have to download or clone this repository, extract the content and copy the "`language-do`" folder in your `.atom/packages`. Restart Atom, and enjoy.  

### Ninja-Install (only for Gnu/Linux):
Open a terminal and paste this line to install the language in one command: 

```
cd ~/.atom && wget https://github.com/rhoconlinux/language-do/archive/master.zip  && unzip master.zip && rm master.zip && cd language-do-master && mv language-do  ~/.atom/packages && rm -Rf ~/.atom/language-do-master && cd

```
^it might work in a mac too, cause is a bash script, but it wasn't tested^

### note:
Obviously when the package is accepted you may find it through **apm**, and you will be able to install it with the following command:

`apm install language-do`


- - -



###### Changelog v 0.2:
>do.cson: added proper comment of "*" (fixed multiplication symbol)
> do.cson: added foreach, by and mata differentiation
> language.do: fixed warning after 'completions':[ 


###### About the author:
<pre>
rhoconlinux.github.com
rhoconlinux.wordpress.com
rho@openmailbox.org
</pre>
