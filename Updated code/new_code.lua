local http = require("socket.http")
local json = require("json")
local ltn12 = require("ltn12")
local lfs = require("lfs")

-- Function to search for images based on a keyword using the Unsplash API
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

-- Function to download an image from a URL
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

-- Function to download images based on keywords and organize them into folders
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

-- Example usage
local function main()
    local keywords = {"cat", "dog", "car", "flower"}  -- Specify keywords for image search
    local per_page = 10                                -- Number of images to fetch per keyword
    local download_folder = "training_images"          -- Folder to save downloaded images
    local client_id = "YOUR_CLIENT_ID"                 -- Replace with your Unsplash API client ID

    download_and_organize_images(keywords, per_page, download_folder, client_id)
end

main()
