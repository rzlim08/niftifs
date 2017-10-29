classdef test_multiple_data < matlab.unittest.TestCase
    properties
        fs;
    end
    methods(TestMethodSetup)
        function createFigure(testCase)
            path_to_test_case = fileparts(fileparts(mfilename('fullpath')));
            testCase.fs = NiftiFS([path_to_test_case filesep 'Test_Data' filesep 'example_data_Multiple_Subjects']);
            assert(exist([path_to_test_case filesep 'Test_Data' filesep 'example_data_Multiple_Subjects'], 'dir')>0)
            set_functional_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep '{scans}']);
            set_subject_strmatch(testCase.fs, 's*');
        end
        function test_subjects(testCase)
            set_subjects(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.path_to_runs,1), 0);
        end
    end
    methods(Test)
        
        function test_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*');
            set_functional_scans(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.functional_scans,1), 214*4);
        end
        function test_get_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*');
            scans = get_functional_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 214*4);
        end
        function test_get_subjScans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*');
            scans = get_subj_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 4);
        end
    end
    
end