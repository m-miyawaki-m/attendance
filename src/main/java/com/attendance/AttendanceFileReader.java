package com.attendance;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class AttendanceFileReader {

    public List<String> readFile(String resourcePath) throws IOException {
        List<String> lines = new ArrayList<>();
        try (InputStream is = getClass().getClassLoader().getResourceAsStream(resourcePath);
                BufferedReader br = new BufferedReader(new InputStreamReader(is))) {
            String line;
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }
}
