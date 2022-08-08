# MThesis

To run this application, you will need Godot. The last version this application was tested on was Godot 3.4. Please note that the beta versions of Godot are not adviced.

Make sure to enable your Android settings in Godot, this can be done using the official guide:
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html

Once that is done, connect your VR headset and you should see an Android Icon appear on the top right of the Godot window. If not, make sure the VR headset is running and not sleeping.

## Custom Object Importing

Make sure your 3D object is a file format that Godot supports (such as .obj). Put the custom 3D object into the Assets folder named Custom.(file_format). Let Godot import it. You should get a message saying that such a file exist and if you would like to override it - do so. Then run the application as usual.
