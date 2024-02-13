package com.attendance;

import static org.junit.Assert.*;

import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;

import org.junit.Test;

public class AttendanceFileFormatTest {

    @Test
    public void testFileFormat() throws IOException {
        AttendanceFileReader reader = new AttendanceFileReader();
        List<String> lines = reader.readFile("attendance_2024_02.txt");

        // 日付のみ、または完全なフォーマットに一致する正規表現
        String regexFull = "^\\d{4}/\\d{2}/\\d{2}\t\\d{2}:\\d{2}\t\\d{2}:\\d{2}\t0.75$";
        String regexDateOnly = "^\\d{4}/\\d{2}/\\d{2}\t\\s*$"; // 修正された正規表現
        Pattern patternFull = Pattern.compile(regexFull);
        Pattern patternDateOnly = Pattern.compile(regexDateOnly);

        int lineNumber = 0;
        for (String line : lines) {
            lineNumber++; // 行番号をインクリメント
            boolean matchesFull = patternFull.matcher(line).matches();
            boolean matchesDateOnly = patternDateOnly.matcher(line).matches();
            assertTrue("Error at line " + lineNumber + ": " + line, matchesFull || matchesDateOnly);
        }
    }
}
