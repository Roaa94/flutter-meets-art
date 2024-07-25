# Flutter Meets Art
Slides and demos created for the talk "**Code Meets Art: Flutter for Creative Coding**" done in [FlutterCon Berlin 2024](https://fluttercon.dev/roaa-khaddam/)

Slides built with [flutter_deck](https://pub.dev/packages/flutter_deck) 🪄

> During tech conferences, people attende talks and workshops to learn about crucial topics that they will hopefully take home and apply in their day-to-day careers to build better apps and software. With this talk, however, my goal is to inspire at least one person from the audience to go home, put aside all their responsibilities, their full time job, clients, product specs, and deadlines, and write code that has one goal and one goal only:
>
>*It paints beautiful pixels on the screen.*
>
> I truly believe that fascinating things can happen when you combine creativity with analytical and algorithmic thinking. When you do that, you become a better developer by being exposed to a universe of creative learning material. You learn data structures by learning how actual trees grow, you learn algorithms used in nature to fly birds or grow cells and use those algorithms to build your server infrastructure or improve a user interface. And being skilled at writing code that paints pixels unlocks your ability to build visualization tooling to help you learn complex concepts and algorithms much faster than you would have otherwise.

**Huge thanks to [Daniel Shiffman](https://thecodingtrain.com/about), the creator of [The Coding Train](https://www.youtube.com/@TheCodingTrain) for his fun and inspiring educational content. His coding challenge "[Weighted Voronoi Stippling](https://www.youtube.com/watch?v=Bxdt6T_1qgc)" was the main inspiration for this talk 🤩**

## Main Demo: Weighted Voronoi Stippling Demo

Inspired by the original tutorial, the concepts of **Delaunay triangulation**, **Voronoi Diagram**, and **lloyd's relaxation algorithm** come together to apply a [stippling](https://en.wikipedia.org/wiki/Stippling#:~:text=Stippling%20is%20the%20creation%20of,are%20frequently%20emulated%20by%20artists.) effect on the camera input, using **Flutter** with its **Canvas API** to read the image pixel colors and paint the shapes on the screen.

I had the main demo running before the talk started, while people were coming in and finding their seats. And it was extremely heart-warming to see people interact and have fun with it 🥹

https://github.com/user-attachments/assets/b62402a7-8911-49e2-85f6-222e0f351c9e

The demo can be found in the [`app`](https://github.com/Roaa94/flutter-meets-art/tree/main/app) folder of this repo, particularly in the [`camera_image_stippling_demo_page.dart`](https://github.com/Roaa94/flutter-meets-art/blob/main/app/lib/widgets/camera/camera_image_stippling_demo_page.dart) file.
I've also added controls to the demo UI. So you can run it, and adjust things like the stippling mode (dots, circles, voronoi polygons, ...etc), the points count (how far can you go before your machine goes 💥? 🫢), colors, dot sizes, ..etc. And you can take a screenshot and share it if you like!

https://github.com/user-attachments/assets/232211f3-9049-47ac-888a-91e289e79a77


https://github.com/user-attachments/assets/069e6ca1-7b83-42c8-b4d1-916245b4f9ad


https://github.com/user-attachments/assets/1f7cc2a8-c7d4-4b47-a174-3b392ab3a5c7


### Side story 📖

For me, the whole point of the talk was the interactive demo experience. And it all depended on me setting up my phone in a way that its camera points at the audience to properly display the camera input and have the effect applied on it. That could have been easily achieved using a phone stand that I had, but being the clumsy, nervous person that I am, I forgot to bring it with me 🤦🏻‍♀️. Thankfully, I had the kindest stage manager who saw me struggling to adjust my phone in a paper cup, had a lightbulb moment, went away, and came back shortly after with a roll of scotch tape that perfectly did the job, so huge thanks to him for being a major part of making this interactive experience possible 🫡😁 

![fluttercon-berlin-2024-scotch-tape](https://github.com/user-attachments/assets/53eaec1d-6ac6-4e33-b06b-711d72a514ab)


## ⚠️ Disclaimers

#### Delaunay implementation

The [`Delaunay` algorithm implementation](https://github.com/Roaa94/flutter-meets-art/blob/main/app/lib/algorithms/delaunay.dart) included in this repo is take from [the `delaunay` Dart package](https://pub.dev/packages/delaunay). I chose to use the code of the package directly because I needed to extend it and modify it a lot. For example, adding `_inedges` and `_hullIndex` lists as well as the `find()` method, of which the implementation was based on the [D3 library's `dellaunay.find()` method](https://github.com/d3/d3-delaunay/blob/main/src/delaunay.js#L122)

#### Buggy Voronoi implementation 🐞

With the limited time I had, I've extended the delaunay implementation with Voronoi diagram implementation that turned out a bit buggy. I've based it on the [guide provided by the original library](https://mapbox.github.io/delaunator/), and handled the infinite polygons at the canvas edges using the method explained in [this tutorial](https://youtu.be/jxOAU7YfypA?t=567), but for reasons beyond what my time allows me to investigate, some weird artifacts happen the edges. The optimal way to handle polygons at the edges would be, again, similar to how the [D3 library handles it](https://github.com/d3/d3-delaunay/blob/main/src/voronoi.js#L255). So that's a ToDo for a time that may never come 🙈, or a great reason to contribute 👀

#### Usage of `RepaintBoundary`

Instead of using the camera image streams, I have chosen to use a `RepaintBoundary` and `Ticker` combination to read the pixels of the screen. I chose this approach for a couple of reasons. The main one is that the image stream implementation of the [`camera_macos`](https://pub.dev/packages/camera_macos) package is buggy and causes the whole app to crash. Another reason is that this way basically any combination of widgets can be the base the stippling is performed on, so feel free to experiment with that! Lastly, with this approach it's easy to control the frame rate and limit the number of times in a second the reasing of the pixels happen for a better perfromance.

#### Web not supported ☹️

Unfortunately, due to many limitations, neither the slides nor the app with its demos run on web. One limitation is that the delaunay algorithm for some reason does not work properly on web, and I have not spent any time to investigate the issue.
Another major limitation is that reading image pixels from the camera is currently not possible on web. The [`camera_web`](https://pub.dev/packages/camera_web#missing-implementation:~:text=Image%20format%20group-,Streaming%20of%20frames,-70) package still does not support image streams and reading pixel data from `RepaintBoundary` wrapping the camera view is not possible.

I really wanted this to work on web so I can host it and make it easily accessible to everyone, but that's a problem that can hopefully be fixed on another day. If anyone has any solution contributions are highly welcome! 🤗

**Here are some solution ideas I've thought of to make this work on web:**

* Using live streaming to get the camera input from another device.
* Using [poisson disk sampling](https://www.youtube.com/watch?v=flQgnCUxHlw) to sample camera input and create a similar effect without the need for the delaunay or voronoi algorithms
* Using [JavaScript interoperability](https://dart.dev/interop/js-interop) to use the algorithms of the original JavaScript libraries.
