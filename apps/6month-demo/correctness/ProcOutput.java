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

public class ProcOutput
{
    private ProcOutput() {
    }
    
    private void merge(String inputFile, String outFilename) {
        try {
            BufferedWriter outFile = new BufferedWriter(new FileWriter(outFilename));
            BufferedReader reader = new BufferedReader(new FileReader(new File(inputFile)));
            String lineNGC;
            
            int uav_count = 0;
            String x = "", y = "", z = "";
            while ((lineNGC = reader.readLine()) != null) {
                if (lineNGC.contains("UAV TRACK")) {
                    uav_count++;
                }
                else if (lineNGC.contains("Target TRACK")) {
                    uav_count++;
                }
                else if (lineNGC.contains("x=")) {
                    x = getValue(lineNGC, "x=");
                }
                else if (lineNGC.contains("y=")) {
                    y = getValue(lineNGC, "y=");
                }
                else if (lineNGC.contains("z=")) {
                    z = getValue(lineNGC, "z=");
                    
                    
                    if (x.startsWith("0") && y.startsWith("0") && z.startsWith("0"))
                        uav_count--;
                    else
                        outFile.write(uav_count + "\t" + x + "\t" + y + "\t" + z + "\n");
                }
            }
            reader.close();
            outFile.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void merge(String inputFile, String uavFilename, String tgtFilename) {
        try {
            BufferedWriter uavFile = new BufferedWriter(new FileWriter(uavFilename));
            BufferedWriter tgtFile = new BufferedWriter(new FileWriter(tgtFilename));
            
            File ngcFile = new File(inputFile);
            
            BufferedReader readerNGC = new BufferedReader(new FileReader(ngcFile));
            String lineNGC;
            
            boolean uav_mode = true;
            int uav_count = 0;
            int tgt_count = 0;
            String x = "", y = "", z = "";
            while ((lineNGC = readerNGC.readLine()) != null) {
                if (lineNGC.contains("UAV TRACK")) {
                    uav_count++;
                    uav_mode = true;
                }
                else if (lineNGC.contains("Target TRACK")) {
                    tgt_count++;
                    uav_mode = false;
                }
                else if (lineNGC.contains("x=")) {
                    x = getValue(lineNGC, "x=");
                }
                else if (lineNGC.contains("y=")) {
                    y = getValue(lineNGC, "y=");
                }
                else if (lineNGC.contains("z=")) {
                    z = getValue(lineNGC, "z=");

                    if (x.startsWith("0") && y.startsWith("0") && z.startsWith("0")) {
                        if (uav_mode)
                            uav_count--;
                        else
                            tgt_count--;
                    }
                    else if (uav_mode)
                        uavFile.write(uav_count + "\t" + x + "\t" + y + "\t" + z + "\n");
                    else
                        tgtFile.write(tgt_count + "\t" + x + "\t" + y + "\t" + z + "\n");
                }
            }
            readerNGC.close();
            uavFile.close();
            tgtFile.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private String getValue(String line, String pattern) {
        int idx = line.indexOf(pattern);
        if (idx < 0) {
            System.out.println("cannot find the pattern " + pattern + " in " + line);
            return null;
        }
        return line.substring(idx + pattern.length());
    }
    
    public static void main(String[] args) {
        ProcOutput oneline = new ProcOutput();
        String dir = "W:/build/apps/MERCURY-RESULTS/results/reverse/";
        
//        oneline.merge(dir + "orange.out", dir + "ownship-part.txt");
//        oneline.merge(dir + "green.out", dir + "target-part.txt");
        
        dir = "W:/build/apps/MERCURY-RESULTS/results/unpartitioned/";
        oneline.merge(dir + "unpartitioned.out", dir + "ownship.txt", dir + "target.txt");
    }
}
