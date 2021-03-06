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
            testCase.verifyEqual(size(testCase.fs.subject_array.get_subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subject_array.get_runs,1), 0);
        end
    end
    methods(Test)
        
        function test_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*.img');
            set_functional_scans(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.get_functional_scans,1), 856);
        end
        function test_get_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*.img');
            scans = get_functional_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 214*4);
        end

        function test_remove_subjects(testCase)
            set_scan_strmatch(testCase.fs, 'fs*.img');
            set_functional_scans(testCase.fs);
            testCase.fs.rm({'s01'});
            subjs = get_subjects(testCase.fs.subject_array);
            testCase.verifyEqual(size(subjs,1),3);
        end
    end
    
end