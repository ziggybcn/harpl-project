@Echo off
Echo Performing add/remove to update mercurial file listing
hg addremove
Echo Sending commit request:
hg commit -u %1
Echo Pushing changes to server
hg push
Echo Done!