# Detailed Explanation

1. **Module Imports**:
   ```lua
   local http = require("socket.http")
   local json = require("json")
   local ltn12 = require("ltn12")
   local lfs = require("lfs")
   ```
   - `socket.http`: For making HTTP requests.
   - `json`: For JSON encoding and decoding.
   - `ltn12`: For managing HTTP response bodies.
   - `lfs`: For filesystem operations like creating directories.

2. **Function `search_images`**:
   ```lua
   local function search_images(keyword, per_page, client_id)
       local url = string.format("https://api.unsplash.com/search/photos?query=%s&per_page=%d", keyword, per_page)
       local headers = {
           ["Authorization"] = "Client-ID " .. client_id
       }
       local response_body = {}
       local res, code, response_headers, status = http.request{
           url = url,
           headers = headers,
           sink = ltn12.sink.table(response_body)
       }
       if code == 200 then
           local response_str = table.concat(response_body)
           local data = json.decode(response_str)
           local image_urls = {}
           for _, photo in ipairs(data.results) do
               table.insert(image_urls, photo.urls.raw)
           end
           return image_urls
       else
           print("Error searching for images:", status)
           return {}
       end
   end
   ```
   - Constructs the API URL with the given `keyword` and `per_page` parameters.
   - Adds the necessary authorization header.
   - Uses `ltn12.sink.table(response_body)` to collect the response body into `response_body`.
   - Checks the HTTP status code and decodes the JSON response to extract image URLs.

3. **Function `download_image`**:
   ```lua
   local function download_image(url, folder)
       local filename = url:match("[^/]*$")
       local filepath = folder .. "/" .. filename
       local file = io.open(filepath, "wb")
       if not file then
           print(string.format("Error opening file for writing: %s", filepath))
           return
       end
       local res, code, response_headers, status = http.request{
           url = url,
           sink = ltn12.sink.file(file),
           timeout = 30 -- Set a timeout of 30 seconds for each request
       }
       if code == 200 then
           print("Downloaded:", filename)
       else
           print(string.format("Error downloading %s: %s", url, status))
       end
   end
   ```
   - Extracts the filename from the URL.
   - Constructs the file path.
   - Opens the file for writing in binary mode.
   - Uses `ltn12.sink.file(file)` to write the response directly to the file.
   - Checks the HTTP status code and prints appropriate messages.

4. **Function `download_and_organize_images`**:
   ```lua
   local function download_and_organize_images(keywords, per_page, download_folder, client_id)
       if not lfs.attributes(download_folder) then
           lfs.mkdir(download_folder)
       end

       for _, keyword in ipairs(keywords) do
           local category_folder = download_folder .. "/" .. keyword
           if not lfs.attributes(category_folder) then
               lfs.mkdir(category_folder)
           end

           local image_urls = search_images(keyword, per_page, client_id)
           for _, url in ipairs(image_urls) do
               download_image(url, category_folder)
           end
       end
   end
   ```
   - Checks if the main download folder exists, and creates it if it doesn't.
   - Iterates over the list of keywords, creating a folder for each keyword if it doesn't exist.
   - Calls `search_images` for each keyword to get image URLs.
   - Calls `download_image` for each image URL to download and save the image.

5. **Main Function**:
   ```lua
   local function main()
       local keywords = {"cat", "dog", "car", "flower"}  -- Specify keywords for image search
       local per_page = 10                                -- Number of images to fetch per keyword
       local download_folder = "training_images"          -- Folder to save downloaded images
       local client_id = "YOUR_CLIENT_ID"                 -- Replace with your Unsplash API client ID

       download_and_organize_images(keywords, per_page, download_folder, client_id)
   end

   main()
   ```
   - Defines the keywords for image search.
   - Sets the number of images to fetch per keyword.
   - Specifies the folder to save downloaded images.
   - Sets the Unsplash API client ID (replace `"YOUR_CLIENT_ID"` with your actual client ID).
   - Calls `download_and_organize_images` with the specified parameters to start the download process.

### Usage
- Replace `"YOUR_CLIENT_ID"` with your actual Unsplash API client ID.
- Run the script. It will create a folder named `training_images`, with subfolders for each keyword, and download the specified number of images into these folders.
