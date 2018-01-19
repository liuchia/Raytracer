## Raytracer
Raytracing is a method of rendering which casts rays to calculate the colour of each pixel. It is slower than most other rendering techniques but can create 'realistic' images.

### Phong Illumination Model
![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Phong_components_version_4.png/655px-Phong_components_version_4.png)
[Phong Illumination](https://en.wikipedia.org/wiki/Elo_rating_system) is the method I used to calculate the intensity of light that hits a certain region. This intensity is composed of ambient, diffuse and specular light. Ambient light provides a minimum intensity as in real life, it is very rare to have some pitch black - light often bounces around and hits stuff. Diffuse uses the dot product of the surface normal and the light source and gives a gradual change in intensity over a surface. Specular light gives a small but incredibly intense highlight.

![](https://i.imgur.com/xkzmVRN.gif)

### Reflections
Reflections can be done in raytracing by reflecting the camera's ray with the surface normal and using that new ray's results to the current pixel. This is done recursively but there is usually a maximum recursion depth of around 5 to help performance.

![](https://i.imgur.com/UnWJ8F2.gif)

### Dividing by Distance
An interesting effect that I copied from [here](https://www.youtube.com/watch?v=duilFGgrgrQ) is the idea of dividing the light intensity by distance. After fiddling around with numbers a bit, I found that increasing the original intensity by a factor and then scaling it back down with distance gave me the best results:

![](https://i.imgur.com/Zyiuwz6.gif)

Shiny :o

