package test;

import java.util.ArrayList;
import java.util.List;


public class Test  {

	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public  static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
//		System.out.println(Utils.getPoint(12.0, 2));df
		Thread t0 = new Thread(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				super.run();
				log("1");

			}
		
			
		};
		
	 
		
		Thread t1 = new Thread(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				super.run();
				log("0");
			}
		
			
		};
		 
		t0.start();
		t1.start();

		
		
	}

	public synchronized static void log(String t){
		for (int i = 0; i < 5; i++) { 
            System.out.println(t+"运行     " + i); 
        } 
	}

}
