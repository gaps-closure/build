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

public class Distance
{
    private Distance() {
    }
    
    private void merge(String ngc, String perspecta, String output) {
        try {
            BufferedWriter fosLog = new BufferedWriter(new FileWriter(output));
            
            File ngcFile = new File(ngc);
            File perspectaFile = new File(perspecta);
            
            BufferedReader readerNGC = new BufferedReader(new FileReader(ngcFile));
            String lineNGC;
            
            BufferedReader readerPL = new BufferedReader(new FileReader(perspectaFile));
            String linePL;
            
            double[] saved = null;
            double[] v;
            while ((lineNGC = readerNGC.readLine()) != null) {
                linePL = readerPL.readLine();
                if (linePL == null)
                    break;

                String line = lineNGC + "\t" + linePL;
                String[] fields = line.split("\\s+");
                if (fields.length < 8) {
                    System.out.println("invalid data: " + line);
                    continue;
                }
                
                v = new double[fields.length];
                for (int i = 0; i < v.length; i++)
                    v[i] = Double.parseDouble(fields[i].trim());
                
                double[] delta = new double[3];
                for (int j = 1, i = 0; i < 3; i++, j++) {
                    delta[i] = v[j] - v[j + 4];
                    
                    line += "\t" + String.format("%.2f", delta[i]);
                }
                
                double sum = 0;
                for (int i = 0; i < 3; i++)
                    sum += delta[i] * delta[i];
                
                double distance = Math.sqrt(sum);
                
                
                fosLog.write(line + "\t" + String.format("%.2f", distance) + "\n");
                
                saved = v;
                
            }
            readerNGC.close();
            readerPL.close();
            fosLog.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        Distance oneline = new Distance();
        
        String dirNGC = null;
        String dirPL = null;
        
        if (args.length == 0) {
            dirNGC = "W:/build/apps/6month-demo/pnt-example-corr/";
            dirPL = "W:/build/apps/6month-demo/correctness/";
        }
        else if (args.length == 2) {
            dirNGC = args[0];
            dirPL = args[1];
        }
        else {
            System.out.println("Usage: prog <NGC dir> <PL dir>");
            System.exit(1);
        }
        
        oneline.merge(dirNGC + "ownship.txt", dirPL + "ownship-part.txt", "./ownship.distances");
        oneline.merge(dirNGC + "target.txt", dirPL + "target-part.txt", "./target.distances");
    }
}
