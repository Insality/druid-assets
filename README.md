# Druid assets

## Overview
I've created  [druid-assets repository](https://github.com/Insality/druid-assets)  to make a  _marketplace_  with custom styles and components.

Any of druid users can push their own components and styles to share it with the other users

Also, this marketplace is great example to how you can create your custom components

## Online app

See [the demo application](https://insality.github.io/druid-assets/)


## How to publish

**Publish your component:**

- Add component to `components` folder (_.lua_ and _.gui_ files)

- Inside this folder, make `example` folder with collection and usage of your component. There is possible to add your graphics assets inside this folder

- Add your collection to monarch in `druid-assets/loader.collection` (see example `component_progress_rich`)

- Add your component info in `resources/components.json`

- Make pull request

- Done!


## License
MIT License

## Issues and suggestions

If you have any issues, questions or suggestions please [create an issue](https://github.com/Insality/druid-assets/issues) or contact me: [insality@gmail.com](mailto:insality@gmail.com)