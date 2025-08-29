Images = {}
ImagesPath = {
}
    
    function loadImages()
        Images = {}
        for i, v in pairs(ImagesPath) do
            if v["Format"] == "svg" then
                Images[i] = svgCreate(v["Width"], v["Height"], v["Path"])
        else
            Images[i] = v["Path"]
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadImages)