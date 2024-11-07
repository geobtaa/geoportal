// Function to dynamically import all channel files
async function importAllChannels() {
  const modules = import.meta.glob('./*_channel.js');
  const importPromises = Object.keys(modules).map(path => modules[path]());
  await Promise.all(importPromises);
}

importAllChannels();
