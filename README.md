# AI Training Data Generator 🤖🖼️

Welcome to the AI Training Data Generator repository! This tool assists in creating datasets for training AI models by fetching and organizing images from the web.

## Overview

AI Training Data Generator is a powerful script written in Lua that leverages the Unsplash API to search for images based on specified keywords. It downloads these images and organizes them into folders based on the provided categories, making it easy to create diverse and labeled datasets for training machine learning and deep learning models.

## Features

- **Fetch images from the web**: Utilize the Unsplash API to search for images based on keywords relevant to your training data.
- **Organize images into folders**: Automatically categorize downloaded images into folders based on the specified keywords.
- **Error handling with retries**: Handle network errors and failed downloads gracefully with built-in retry mechanisms.
- **Logging of download activities**: Keep track of downloaded images and any errors encountered during the download process.
- **Pagination support**: Fetch multiple pages of images to create larger and more comprehensive datasets.
- **Easily customizable and configurable**: Adjust parameters such as keyword, number of images per keyword, and download folder to suit your specific requirements.

<div align="center">
  <img width="645" alt="image concept maybe working" src="https://github.com/Rishit-katiyar/AI-Training-Data-Generator/assets/167756997/da62efd9-9aab-4bc9-a559-124d2303f851">
</div>

## Installation

To use the AI Training Data Generator, follow these steps:

1. **Clone the Repository**: 
    ```bash
    git clone https://github.com/Rishit-katiyar/AI-Training-Data-Generator.git
    cd AI-Training-Data-Generator
    ```

2. **Install Lua and LuaRocks**: 
   - Lua is a lightweight scripting language. You can download it from [Lua.org](https://www.lua.org/download.html).
   - LuaRocks is the Lua package manager. Install it from [LuaRocks.org](https://luarocks.org/).

3. **Install Dependencies**:
   - Use LuaRocks to install required Lua modules:
     ```bash
     luarocks install luafilesystem
     luarocks install luasocket
     luarocks install lua-cjson
     ```

4. **Get Unsplash API Key**:
   - Sign up for a free account at [Unsplash Developer](https://unsplash.com/developers) to obtain your API key.

5. **Set API Key**:
   - Replace `"YOUR_CLIENT_ID"` in `generate_training_data.lua` with your actual Unsplash API client ID.

## Usage

1. **Modify Keywords**:
   - Edit the `keywords` table in `generate_training_data.lua` to specify the keywords for image search.

2. **Specify Parameters**:
   - Adjust other parameters such as `per_page` (number of images per keyword) and `download_folder` as needed.

3. **Run the Script**:
   - Execute the script:
     ```bash
     lua generate_training_data.lua
     ```

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Additional Resources

For more information and resources on AI and image processing, check out the following links:

- [Deep Learning Specialization](https://www.coursera.org/specializations/deep-learning) - A comprehensive series of courses on deep learning by Andrew Ng on Coursera.
- [Python for Data Science and Machine Learning Bootcamp](https://www.udemy.com/course/python-for-data-science-and-machine-learning-bootcamp/) - A popular course on Python for data science and machine learning on Udemy.
- [Unsplash API Documentation](https://unsplash.com/documentation) - Official documentation for the Unsplash API.

Feel free to explore and experiment with different keywords and parameters to create diverse and customized datasets for your AI projects!
