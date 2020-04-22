/*******************************************************************************
 * Copyright (c) 2018 Perspecta Labs Inc  - All Rights Reserved.
 * Proprietary and confidential. Unauthorized copy or use of this file, via
 * any medium or mechanism is strictly prohibited. 
 *  
 * @author tchen
 *******************************************************************************/
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class LossDetect
{
    private LossDetect() {
    }
    
    private double[] getXYZ(String line) {
        String[] fields = line.split("\\s+");
        if (fields.length < 4) {
            System.out.println("invalid data: " + line);
            return null;
        }
        
        double[] v = new double[3];
        for (int i = 1; i < 4; i++)
            v[i - 1] = Double.parseDouble(fields[i].trim());
        
        return v;
    }
    
    private void merge(String sendName, String recvName, String lossName) {
        try {
            BufferedWriter lossWriter = new BufferedWriter(new FileWriter(lossName));
            BufferedReader readerSender = new BufferedReader(new FileReader(new File(sendName)));
            BufferedReader readerRecver = new BufferedReader(new FileReader(new File(recvName)));
            String lineSend = null;
            String lineRecv = null;

            int loss_count = 0;
            double[] recv = null;
            while ((lineSend = readerSender.readLine()) != null) {
                double[] send = getXYZ(lineSend);
                if (send == null) {
                    continue;
                }
                if (recv == null) {
                    lineRecv = readerRecver.readLine();
                    if (lineRecv != null) {
                        recv = getXYZ(lineRecv);
                    }
                }
                if (recv == null) {
                    loss_count++;
                    lossWriter.write(lineSend + "\n");
                    System.out.println(lineSend);
                    continue;
                }
                boolean loss = false;
                for (int i = 0; i < send.length; i++) {
                    if (send[i] < recv[i]) {
                        loss = true;
                        break;
                    }
                }
                if (loss) {
                    loss_count++;
                    lossWriter.write(lineSend + "\n");
                    System.out.println(lineSend);
                }
                else {
                    recv = null; // read again
                }
            }
            lossWriter.write("Total loss: " + loss_count + "\n");
            System.out.println("Loss: " + loss_count);
            
            readerSender.close();
            readerRecver.close();
            lossWriter.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        LossDetect oneline = new LossDetect();
        String dir = "W:/build/apps/6month-demo/correctness/";
        
        if (args.length != 0) {
            if (args.length >= 1) {
                dir = args[0];
            }
            else {
                System.out.println("Usage: prog <dir> <data type> <g|o> <o|g>");
                System.exit(1);
            }
        }
        
        String[] types =     { "ownship", "ownship", "rfs" };
        String[] senders =   { "g",       "o",       "o" };
        String[] receivers = { "o",       "g",       "g" };
        
        for (int i = 0; i < types.length; i++) {
            String sendFile = dir + types[i] + "-" + senders[i] + "-snd.txt"; 
            String recvFile = dir + types[i] + "-" + receivers[i] + "-rcv.txt";
            String lossFile = dir + types[i] + "-" + senders[i] + "-" + receivers[i] + "-loss.txt";
            oneline.merge(sendFile, recvFile, lossFile);
        }
    }
}
