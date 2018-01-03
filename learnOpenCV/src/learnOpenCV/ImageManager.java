package learnOpenCV;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfByte;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

public class ImageManager {

	private static EdgeDetector edgeDet = new EdgeDetector();

	public static void main(String[] args) throws IOException {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

		ImageManager ref = new ImageManager();
		String imagePath = "images/moderate.jpg";
		// Zoom
		Mat origImg = ref.readImage(imagePath, false);
		// ref.showResult(ref.zoomMat2BufferedImage(origImg, 2));

		Mat grayImg = ref.readImage(imagePath, true);
		// ref.showResult(re.Mat2BufferedImage(grayImg));

		// Canny Edge Detection
		Mat cannyImg = edgeDet.detectCannyEdges(grayImg);
		//ref.showResult(ref.Mat2BufferedImage(cannyImg));

		Mat lineImg = edgeDet.drawHoughLines(origImg, cannyImg);
		ref.showResult(ref.Mat2BufferedImage(lineImg));
	}

	public Mat readImage(String imagePath, boolean gray) {
		// Loads an image from a file.
		Mat img = Imgcodecs.imread(imagePath,
				(gray) ? Imgcodecs.CV_LOAD_IMAGE_GRAYSCALE : Imgcodecs.CV_LOAD_IMAGE_COLOR);
		return img;
	}

	public BufferedImage Mat2BufferedImage(Mat m) {
		// First read
		int type = (m.channels() > 1) ? BufferedImage.TYPE_3BYTE_BGR : BufferedImage.TYPE_BYTE_GRAY;
		byte[] b = new byte[m.channels() * m.cols() * m.rows()];
		m.get(0, 0, b); // get all the pixels

		// Now write
		BufferedImage image = new BufferedImage(m.cols(), m.rows(), type);
		final byte[] targetPixels = ((DataBufferByte) image.getRaster().getDataBuffer()).getData();
		System.arraycopy(b, 0, targetPixels, 0, b.length);

		return image;
	}

	public BufferedImage zoomMat2BufferedImage(Mat m, int zoomFactor) throws IOException {
		// Zoom up
		Mat dest = new Mat(m.rows() * (int) zoomFactor, m.cols() * (int) zoomFactor, m.type());
		dest = m;
		Imgproc.pyrUp(m, dest, dest.size());
		// OR
		Imgproc.resize(m, dest, dest.size(), zoomFactor, zoomFactor, Imgproc.INTER_NEAREST);

		MatOfByte matOfByte = new MatOfByte();
		// Encodes an image into a memory buffer.
		Imgcodecs.imencode(".jpg", m, matOfByte);
		byte[] byteArray = matOfByte.toArray();
		InputStream in = new ByteArrayInputStream(byteArray);
		BufferedImage bufImage = ImageIO.read(in);
		return bufImage;
	}

	public void showResult(BufferedImage img) {
		try {
			JFrame frame = new JFrame();
			frame.getContentPane().add(new JLabel(new ImageIcon(img)));
			frame.pack();
			frame.setVisible(true);
			frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
