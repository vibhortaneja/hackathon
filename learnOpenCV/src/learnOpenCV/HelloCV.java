package learnOpenCV;

import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;

public class HelloCV {
	public static void main(String[] args) {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		// Mat: n-dimensional dense numerical single-channel or multi-channel array.
		Mat mat = Mat.eye(3, 3, CvType.CV_8UC1);// identity matrix of 3x3
		System.out.println("mat = " + mat.dump());
	}
}
