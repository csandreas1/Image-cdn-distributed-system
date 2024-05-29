<?php

namespace App\Http\Controllers;

use App\Jobs\UploadImageToCDN;
use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ImageController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        // Store the image locally first
       $stored = Storage::disk('image_sync')->putFile('node1_data',  $request->file('image'));

        # UploadImageToCDN::dispatch($path);
        if ($stored)
        return response()->json(['success'=>'You have successfully uploaded an image.'], 201);
        else {
            return response()->json(['fail'=> 'failed'], 422);

        }

    }

    public function show($id)
    {
        $image = Image::find($id);

        if ($image) {
            return response()->json(['image' => asset($image->file_path)], 200);
        } else {
            return response()->json(['error' => 'Image not found'], 404);
        }
    }
}
