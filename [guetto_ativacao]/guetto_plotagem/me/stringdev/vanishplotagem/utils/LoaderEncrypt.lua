local loaded = { }

function loadImgEncrypted(path, ...)
    if (loaded[path]) then
        return loaded[path]
	end
    
    if not (path:find(".png_encrypted")) then
        if path and fileExists(path) then 
            loaded[path] = dxCreateTexture(path, ...)
            return loaded[path]
        end
    end

	local split_string = path:split(".")
	local decrypted = nil

	if ((split_string[#split_string]):sub(-10) == "_encrypted") then
        local compiledStr
		local compiledFile = File.open(path, true)
        if (compiledFile) then
            compiledStr = fileRead(compiledFile, fileGetSize(compiledFile))
            fileClose(compiledFile)
        end

		decrypted = base64Decode(decryptString(compiledStr))
	else
	    loaded[path] = dxCreateTexture(path, ...)
        return loaded[path]
	end

    local fileNameNew = "resources/textures/"..sha256(path)..".tex"
    local fileImg = fileCreate(fileNameNew)
	local written = fileWrite(fileImg, decrypted)
	fileClose(fileImg)

    local texture = dxCreateTexture(fileNameNew, ...)
	loaded[path] = texture

    fileDelete(fileNameNew)
	return loaded[path]
end

function decryptString(str)
	if not (str) then return "" end
	
    return decodeString("tea", str, { key = config["PasswordVTR"] })
end