package learnOpenCV;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;

/*
 * Canny edge detection is a four step process:
 * 1. A Gaussian blur is applied to clear any speckles and free the image of noise.
 * 2. A gradient operator is applied for obtaining the gradients’ intensity and direction.
 * 3. Non-maximum suppression determines if the pixel is a better candidate for an edge than its neighbors.
 * 4. Hysteresis thresholding finds where edges begin and end.
 * 
 * The Canny algorithm has 2 adjustable parameters:
 * 1. The size of the Gaussian filter: Smaller filters cause less blurring, and allow detection of small, sharp lines. 
 * 2. Thresholds: A threshold set too high can miss important information.
 */
public class EdgeDetector {

	private int filterSize = 3;
	private int threshold = 40;

	private Scalar redLine = new Scalar(0, 255,0);
	private double rho = 1;
	private double theta = Math.PI / 180;
	private double minLineLength = 0;
	private double maxLineGap = 0;
	private int thickness = 1;

	public Mat detectCannyEdges(Mat grayImage) {
		Mat cannyImg = new Mat();

		Mat detectedEdges = new Mat();
		// reduce noise with a 3x3 kernel
		Imgproc.blur(grayImage, detectedEdges, new Size(filterSize, filterSize));
		// canny detector, with ratio of lower:upper threshold of 3:1/2:1
		Imgproc.Canny(detectedEdges, detectedEdges, threshold, threshold * 3);

		// using Canny's output as a mask, display the result
		grayImage.copyTo(cannyImg, detectedEdges);
		return cannyImg;
	}

	public Mat drawHoughLines(Mat origImg, Mat cannyImg) {
		Mat detectedLines = new Mat();
		// Probabilistic Algo needs lower threshold - so take square root
		Imgproc.HoughLinesP(cannyImg, detectedLines, rho, theta, (int) Math.sqrt(threshold), minLineLength, maxLineGap);
		Point pt1, pt2 = null;
		int r = 0;
		double length = 0;
		for (r = 0; r < detectedLines.rows(); r++) {
			double[] row = detectedLines.row(r).get(0, 0);
			pt1 = new Point(row[0], row[1]);
			pt2 = new Point(row[2], row[3]);
			length += Core.norm(new MatOfPoint(pt1), new MatOfPoint(pt2));
			Imgproc.line(origImg, pt1, pt2, redLine, thickness);
		}
		System.out.println("No of lines " + r + " total length " + length);
		if(r<100){
			System.out.println("The mobile screen is free of any cracks");
		}
		else if(r>100 && r<2500){
			System.out.println("The mobile screen is moderately cracked");
		}
		else {
			System.out.println("The mobile screen is heavily cracked");
		}
		return origImg;
	}

}
