function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }
  
  for each video in playlist.videos
    
    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
function BrightcovePlayerAPI()
  this = {
    GetPlaylistData: GetPlaylistData
  }
  return this
end function

function GetPlaylistData()
  playerURL = Config().playerURL

  
  accountStart = Instr(1, playerURL, "brightcove.net/") + 15
  accountEnd = Instr(accountStart, playerURL, "/")
  accountId = Mid(playerURL, accountStart, accountEnd - accountStart)
  print "Using account ID "; accountId

  
  playlistStart = Instr(1, playerURL, "playlistId=") + 11
  playlists = []
  if playlistStart > 11
    playlists.push(Mid(playerURL, playlistStart))
  end if

  
  
  repoEnd = Instr(accountEnd + 1, playerURL, "/")
  shortenedURL = Left(playerURL, repoEnd)
  configURL = shortenedURL + "config.json"
  print "Getting data from " ; configURL

  
  configData = GetStringFromURL(configURL)
  configJson = ParseJSON(configData)
  PrintAA(configJson)

  
  policyKey = configJson.video_cloud.policy_key

  out = {
    playlists: []
  }
  for each playlistId in playlists
    out.playlists.push(GeneratePlaylist(accountId, playlistId, policyKey))
  next

  return out
end function

function GeneratePlaylist(accountId, playlistId, policyKey)
  print "Getting playlist data for " ; playlistId
  playbackUrl = "https://edge.api.brightcove.com/playback/v1/accounts/" + accountId + "/playlists/" + playlistId
print playbackUrl
  playlistData = GetStringFromURL(playbackUrl, policyKey)
  playlist = ParseJSON(playlistData)
  
  rokuPlaylist = {
    playlistID: ValidStr(playlist.id),
    shortDescriptionLine1: ValidStr(playlist.name),
    shortDescriptionLine2: Left(ValidStr(playlist.description), 60),
    content: []
  }

  
  for each video in playlist.videos
    

    newVid = {
      id:                      ValidStr(video.id),
      contentId:               ValidStr(video.id),
      shortDescriptionLine1:   ValidStr(video.name),
      title:                   ValidStr(video.name),
      description:             ValidStr(video.description),
      synopsis:                ValidStr(video.description),
      sdPosterURL:             ValidStr(video.poster),
      hdPosterURL:             ValidStr(video.poster),
      length:                  Int(video.duration / 1000),
      
      streams:                 [],
      streamFormat:            "mp4",
      contentType:             "episode",
      categories:              []
    }

    date = CreateObject("roDateTime")
    
    tLoc = Instr(1, video.published_at, "T")
    pubLen = Len(video.published_at)
    fixedPubAt = Left(video.published_at, tLoc - 1) + " " + Mid(video.published_at, tLoc + 1, pubLen - tLoc - 1)
    
    date.FromISO8601String(fixedPubAt)
    newVid.releaseDate = date.asDateStringNoParam()
    for each tag in video.tags
      
      newVid.categories.Push(ValidStr(tag))
    next
    for each source in video.sources
      
      
      if UCase(ValidStr(source.container)) = "MP4" and UCase(ValidStr(source.codec)) = "H264" and source.src <> invalid
        newStream = {
          url:  ValidStr(source.src),
          bitrate: Int(StrToI(ValidStr(source.avg_bitrate)) / 1000)
        }

        if StrToI(ValidStr(source.height)) > 720
          video.fullHD = true
        end if
        if StrToI(ValidStr(source.height)) > 480
          video.isHD = true
          video.hdBranded = true
          newStream.quality = true
        end if
        newVid.streams.Push(newStream)
      end if
    next
    rokuPlaylist.content.Push(newVid)
  next

  return rokuPlaylist
end function
