<html>
<head>
<title>CS 385 Final Project</title>
<link href='http://fonts.googleapis.com/css?family=Nunito:300|Crimson+Text|Droid+Sans+Mono' rel='stylesheet' type='text/css'>
<link rel="stylesheet" title="Default" href="styles/github.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>  

<link rel="stylesheet" href="highlighting/styles/default.css">
<script src="highlighting/highlight.pack.js"></script>

<style type="text/css">


body {
	margin: 0px;
	width: 100%;
	font-family: 'Crimson Text', serif;
	font-size: 20px;
	background: #fcfcfc;
}



h1 {
	font-family: 'Nunito', sans-serif;
	font-weight: normal;
	font-size: 28px;
	margin: 25px 0px 0px 0px;
	text-transform: lowercase;

}

h2 {
	font-family: 'Nunito', sans-serif;
	font-weight: normal;
	font-size: 32px;
	margin: 15px 0px 35px 0px;
	color: #333;	
	word-spacing: 3px;
}

h3 {
	font-family: 'Nunito', sans-serif;
	font-weight: normal;
	font-size: 26px;
	margin: 10px 0px 10px 0px;
	color: #333;
	word-spacing: 2px;
}
h4 {
	font-family: 'Nunito', sans-serif;
	font-weight: normal;
	font-size: 22px;
	margin: 10px 0px 10px 0px;
	color: #333;
	word-spacing: 2px;
}

h5 {
	font-family: 'Nunito', sans-serif;
	font-weight: normal;
	font-size: 18px;
	margin: 10px 0px 10px 0px;
	color: #111;
	word-spacing: 2px;
}

p, li {
	color: #444;
}

a {
	color: #DE3737;
}

.container {
	margin: 0px auto 0px auto;
	width: 1160px;
}

#header {
	background: #333;
	width: 100%;
}

#headersub {
	color: #ccc;
	width: 960px;
	margin: 0px auto 0px auto;
	padding: 20px 0px 20px 0px;
}

.chart {
	width: 480px;
}
.lol {
	font-size: 16px;
	color: #888;
	font-style: italic;
}
.sep {
	height: 1px;
	width: 100%;
	background: #999;
	margin: 20px 0px 20px 0px;
}
.footer{
	font-size: 16px;
}
.latex {
	width: 100%;
}

.latex img {
	display: block;
	margin: 0px auto 0px auto;
}

pre {
	font-family: 'Droid Sans Mono';
	font-size: 14px;
}

table td {
  text-align: center;
  vertical-align: middle;
}

table td img {
  text-align: center;
  vertical-align: middle;
}

#contents a {
}
</style>
<script type="text/javascript">
    hljs.initHighlightingOnLoad();
</script>
</head>
<body>
<div id="header" >
<div id="headersub">
<h1>My Awesome Super Cool Team <br><span style="color: #DE3737">(by Joe Mogannam, Ben Levinsky, Blair Bickel)</span></h1>
</div>
</div>
<div class="container">

<h2>CS 385 : TextonBoost - Parking Lots</h2>

<div style="float: right; padding: 20px">
<img src=".\html\download.jpeg" />
<p style="font-size: 14px">Example of a right floating element.</p>
</div>
<h3>Introduction</h3>
<p>
    TextonBoost is an approach to multi-class classification that attempts to segment photographs into various classes. This model seeks to use texture-layout filters, or features based on textons.
    <br>
    Classification and feature selection is achieved using boosting to give an efficent classifier which can be applied to a large number of classes.
</p>
<ul>
    <li>
        The aim of our project was to apply TextonBoost to determine where there are occupied and vacant spaces in a parking lot.
    </li>
    <li>
        Initially, the codebase worked on 24 classes, but we had to sift through the codebase and instead add two new categories, occupied and unoccupied.
    </li>
    <li>
        Our team leveraged two datasets to train our model for this purpose. The PKLot and UIUC datasets, each housing many images that show cars and parking spaces in different poses and/or lighting conditions.
    </li>
    <li>
        When using the UIUC dataset, the images had varying results, but when using the PKLot dataset with default parameters, We were able to determine where some occupied spots were with relatively little difficulty.
    </li>
</ul>
<hr>
<h3> Approach/Algorithm </h3>

<p> A simplified explanation of TextonBoost is: <br><br>
    Learn a boosting classifier based on relative texture locations for each class. The classification is then refined by combining various weak classifiers and then combining them to construct a classifier that has a higher accuracy than any of the individual classifiers would produce on their own.
    <br>
    </p>
    <u>Pre-existing Algorithm</u>
    <p>
    <ol>
    Given an image and for each pixel:
        <li>Texture-Layout features are calculated </li>

        <li>A boosting classifier gives the probability of the pixel belonging to each class</li>
        <li>The model combines the boosting output with shape, location, color and edge information</li>
        <li>Pixel receives final label.</li>
        <li>Image receives final label.</li>

    </ol>
    </p>


<p>
<u>Extensions to existing TextonBoost framework</u>
<br> <ul>
        <li>The original algorithm used a filter bank with 3 Gaussians, 4 Laplacian of Gaussians and 4 first order derivatives of Gaussians.
                In addition to these filters, we augmented the filter bank to also use dense SIFT.
                Dense SIFT differs from regular SIFT in that dense SIFT assumes every pixel is a point of interest.
                We also modified the approach of the framework to only care about 3 classes, void, car, unoccupied.</li>
        <li> When working with the data set UIUC, the algorithm needed to be altered to account for gray scale images.
                To process a gray scale image they first need to converted to a 3 dimensional image matrix to simulate an RGB image matrix.
                Than the code needs to be altered, so that Hue and Saturation are not used when textonizing images. Removing Hue and Saturation results
                in decreasing the number of features per pixel from 17 to 11.
        </li>
    </ul>

<u>Tweaking the Parameters</u>
<ul>
    <li>The pixel feature descriptors that were aggregated from applying the various filters are clustered using k-means.
            We varied the value of k for k-means clustering to determine the optimal number of clusters for our model.</li>
    <li>Additionally, to balance the trade-off between too much noise in the image from image textonization, keeping enough information for accuracy
            and speed of training, the image in testing and the training set are sampled with a filter.
            We also varied the size of the filter used in the various filter banks that already existed in the framework.</li>
    <li> When using the UIUC data set, the number of features decreases from 17 to 11.
            So the parameter numFeatures in the file imgTextonization.m must be changed to 11. This parameter change
            will account for less features used, and result in a smaller code book generated.</li>

</ul>
</p>

<div style="clear:both">
    <hr>
<h3>Results</h3>

    <ol>
        <li> Problems with Input Images</li>
        <ul>


            <li> All of the Input Images in the PKLot data set span a large parking lot. Since the input images are not taken
                from the zenith of the center of the parking lot, the resulting images will result in objects of varying size
                because parking spaces at one of end of the lot can be much smaller than spaces at another end of the lot.
                The objects (e.g. cars, unoccupied spots, etc.) in the foreground will be much larger and more defined
                than the objects in the background. To account for this problem we cropped the original images to capture
                a small location, where the object's have less varying sizes.  </li>
        </ul>
        <li> Problems with Ground Truth Images</li>
            <ul>
                <li> In a perfect world the Ground Truth Images should have every pixel colored as either void, car, or unoccupied.
                    Unfortunately because the PKLot metadata associated with the images did not describe complex polygons
                    that exactly match the contours of a car in a parking spot. Instead the PKLot data set simply provided rectangles
                    that approximately cover a parking spot. This metadata causes issues because there is extraneous information
                    used to describe a car. This means that if, for example, there is a crowded parking lot in the training set
                    and we have a given spot as empty, the model will train on ground truth images that have shadows from
                    adjacent cars and think that these shadows characterize an empty spot.

                </li>
                <li>
                    In addition, the Ground Truth metadata provided by PKLot also has a small subset of polygons that would overlap with each other.
                    This will cause issues in the training phase because pixels associated with a given class can be classified inaccurately.
                    For example, consider an empty parking spot with two cars on each side of it. If the Ground Truth image for an occupied spot covers
                    a portion of the two cars, unwanted textures will be introduced to describe the unoccupied spot's class category.

                </li>

            </ul>

    </ol>


<center><h1>Our new color classes</h1><img src=".\html\somecode.png" /></center>

<h3>Output Images</h3>

<table width="1300" border=1>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\firstpipelinewithsift.png"  />
                <figcaption> First Pipeline with only SIFT features</figcaption>
            </figure>
        </td>
        </tr>
    <tr>
        <td width="1200" height="200">

            <figure width="48%" height="90%">
                <img src=".\html\pic_withandwithoutsift_for1imagefortrainandtest.png"  />
                <figcaption>First pipeline with both SIFT and filter bank features</figcaption>
            </figure>

        </td>

    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\UIUC_w-oSift_noH-S.png" width="48%" height="90%"/>
                <figcaption>UIUC dataset with only filter bank features</figcaption>
            </figure>
        </td>
    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\Using11_trainImages_withSift.png"  width="48%" height="90%"/>
                <figcaption>UIUC dataset with only SIFT features</figcaption>
            </figure>
        </td>
    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\Train-TestSegmentedWithSift_nocar.png"  width="48%" height="90%"/>
                <figcaption>PKLot dataset trained with segmented images with only SIFT features</figcaption>
            </figure>
        </td>
    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\Using11_Full_tainiImages_noSift.png"  width="48%" height="90%"/>
                <figcaption>PKLot dataset trained with segmented images with only filter bank features</figcaption>
            </figure>
        </td>
    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\UIUIC_Test-Train_sameimages_clusters5.png"   width="48%" height="90%"/>
                <figcaption>UIUC dataset trained with segmented images with both filter bank and SIFT features and 5 clusters in k-means clustering</figcaption>
            </figure>
        </td>
    </tr>
    <tr>
        <td width="1200" height="200">
            <figure width="48%" height="90%">
                <img src=".\html\UIUIC_Test-Train_sameimages_clusters10.png"   width="48%" height="90%"/>
                <figcaption>UIUC dataset trained with segmented images with both filter bank and SIFT features and 10 clusters in k-means clustering</figcaption>
            </figure>
        </td>
    </tr>


</table>



<h2>Some figures</h2>
    <figure>
        <img src=".\html\unoccupiedgraph2.jpg">
        <figcaption>
            Graph plotting False Negative vs. True Positive in varying outputs for unoccupied parking spots
        </figcaption>
    </figure>
    <figure>
        <img src=".\html\occupied_graph1.jpg">
        <figcaption>
            Graph plotting False Negative vs. True Positive in varying outputs for unoccupied parking spots
        </figcaption>
    </figure>
    <figure>
        <img src=".\html\RPC_UnOccupied.png">
        <figcaption>
            RPC curve for unoccupied classification when varying number of clusters <br>
            Legend: <br>
            Point 10: Number of Clusters = 10.  <br>
            Point 3: Number of Clusters = 3. <br>
            Point 5: Number of Clusters = 5. <br>
            Point 20: Number of Clusters = 20. <br>
        </figcaption>
    </figure>
    <figure>
        <img src=".\html\RPC_Occupied.png">
        <figcaption>
            RPC curve for occupied classification when varying number of clusters <br>
            Legend: <br>
            Point 10: Number of Clusters = 10.  <br>
            Point 3: Number of Clusters = 3. <br>
            Point 5: Number of Clusters = 5. <br>
            Point 20: Number of Clusters = 20. <br>
        </figcaption>
    </figure>

    <hr>



<h3>Discussion and Conclusions</h3>
<div style="clear:both" >

    In hindsight, TextonBoost was limited by our data set, the code base, and the similarity of the classes.


        <br>
        <ul>
            <li>
                The codebase seemed to use k-means clustering at an odd time. We posited that k-means clustering should be used on <u>all</u> of the data at one time. Instead,
                the codebase seemed to use k-means clustering <u>on each image</u> independent of the other images.
            </li>
            <li>
                Understanding all the various pieces that made the code run, from textonization to training of the model, all involved multiple files and assumed the user of the framework
                had an intimate understanding of the approach.
            </li>
            <li>
                Introducing dense SIFT was a challenge because the filter-bank used initially on each pixel worked on all pixels. Unfortunately, dense SIFT cannot operate on pixels too close to a boundary.
                Our team overcame this challenge by adjusting the size that the filter-bank dealt with to the same dimensions as the dense-SIFT portion of the image.
            </li>
            <li>
                Trying to find a good data set was difficult. While testing the functionality of our code we came across many problems caused by input images.
                With the PKLot data set one of the most obvious problems we noticed was that objects' size varied based on location within the image. In order to
                get input images with objects of relatively similar size we cropped a small area out of the original images in the PKLot data set.
                Cropping the original images also had the benefit of speeding up the code because there would be less pixels to train on.
            </li>
            <li>We also tried cropping individual objects of interest out of the PKLot data set images.
                Cropping individual images provided an additional data set, where we could train on either cars or empty parking spots.
                The difference between these segmented images and the original images with an entire parking lot in view is that the
                original images included other objects like grass, roads, & people that could interfere with training.
                The result of these segmented images provided input images with less noise.
            </li>

        </ul>


</div>


    <hr>
    <br>


    <br>
    #Setup
	*	download project
	*	move project into documents/matlab/ directory
	*	unzip the project
	*	Open Matlab
	*	use “set path” and click “add with subfolders”  to add all the contents of Project directory to Matlab
	*	In matlab, in the home tab, open run.m in project directory
	*	in run.m, make sure the current folder path is set, otherwise it will try to use matlab built in run commands. 
	*	To set the current folder path: 
	*	In the matlab Editor environments, right click on the file name. (Not the Current folder, but the editor tab)
	*	 click “change Current Folder to “…. Folder Path to use …..” “
	*	 then in the command line run the command , “run(-1)”


#Important Files

*imagesTextonization — extract sextons for images
*calcModlFeatures — calculate space potential context
*trainModel — build boosting model
*testModel - test classifier with test data



<h3>References</h3>
    <a href="http://download.microsoft.com/download/3/3/9/339D8A24-47D7-412F-A1E8-1A415BC48A15/msrc_objcategimagedatabase_v2.zip">MSRC framework from Microsoft</a>
    <br>
    <a href="https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/ijcv07a.pdf">Research paper from Microsoft</a>
    <br>
    <a href="http://www.cs.tau.ac.il/~yanivba1/ML2012_fp_yaniv_bar.pdf">TextonBoost framework in Matlab documentation</a>

    <br>
    <br>
    <br>
    <br>
    <br>
</div></div>
</body>
</html>
