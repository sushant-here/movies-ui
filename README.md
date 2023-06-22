```
 ________________________
< Everybody loves movies >
 ------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

#  Movies!

This project is a sample Swift UI app that connects http://themoviedb.org and displays a list of movies and a detail page for those individual movies. 

I am still relativly new to Swift UI so I may have done things in - not so optimal ways.

## Getting started

The project dependencies are managed by Swift Package Manager. I have built this using XCode 14.3. You should also be able to use a older versions of XCode.  

1. Create a developer account: https://developer.themoviedb.org/docs/getting-started
2. Obtain a `API Read Access Token` from themoviedb.
3. In Xcode project open (command + shift + o) `TheMovieDB.plist` and place the access token in the plist file.
4. Press build.

## General architecture

- Have used MVVM architecture
- Dependency injection setup using custom @Inject PropertyWrappers.
- Unit tests are (practically) all BDD written with Quick/Nimble framework.
- Strings are stored in .strings files and are surfaced into the models using R.swift.
- Images are fetched and cached in memory using Kingfisher library.
