local http = require("socket.http")
local json = require("json")
local ltn12 = require("ltn12")
local lfs = require("lfs")
local os = require("os")

-- Function to search for images based on a keyword using the Unsplash API
local function search_images(keyword, per_page, client_id)
    local url = string.format("https://api.unsplash.com/search/photos?query=%s&per_page=%d", keyword, per_page)
    local headers = {
        Authorization = "Client-ID " .. client_id
    }
    local response, code, headers, status = http.request{
        url = url,
        headers = headers
    }
    if code == 200 then
        local data = json.decode(response)
        local image_urls = {}
        for _, photo in ipairs(data.results) do
            table.insert(image_urls, photo.urls.raw)
        end
        return image_urls, data.total_pages
    else
        print("Error searching for images:", status)
        return {}, 0
    end
end

-- Function to download an image from a URL
local function download_image(url, folder)
    local filename = url:match("[^/]*$")
    local filepath = folder .. "/" .. filename
    local retries = 3
    while retries > 0 do
        local response, code, headers, status = http.request{
            url = url,
            sink = ltn12.sink.file(io.open(filepath, "wb")),
            timeout = 30 -- Set a timeout of 30 seconds for each request
        }
        if code == 200 then
            print("Downloaded:", filename)
            return true
        else
            print(string.format("Error downloading %s: %s", url, status))
            retries = retries - 1
        end
    end
    return false
end

-- Function to download images based on keywords and organize them into folders
local function download_and_organize_images(keywords, per_page, download_folder, client_id)
    if not lfs.attributes(download_folder) then
        lfs.mkdir(download_folder)
    end

    local log_file = io.open("download_log.txt", "a")
    log_file:write("Download Log - " .. os.date() .. "\n\n")

    for _, keyword in ipairs(keywords) do
        local category_folder = download_folder .. "/" .. keyword
        if not lfs.attributes(category_folder) then
            lfs.mkdir(category_folder)
        end

        local total_pages = 1
        local page = 1
        while page <= total_pages do
            local image_urls, pages = search_images(keyword, per_page, client_id)
            total_pages = pages

            for _, url in ipairs(image_urls) do
                local success = download_image(url, category_folder)
                if success then
                    log_file:write("Downloaded: " .. url .. "\n")
                else
                    log_file:write("Failed to download: " .. url .. "\n")
                end
            end

            page = page + 1
        end
    end

    log_file:close()
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
