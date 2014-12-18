{QuillFirebase} = require './lib/quill_firebase'

# Client-side stuff here
# Initialize the material effects
$.material.init()

if $("#full-editor").length
  # Initialize the quill editor
  qf = new QuillFirebase("#editor", "#toolbar")
  qf.init()
