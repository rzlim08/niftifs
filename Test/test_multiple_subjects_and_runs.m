classdef test_multiple_subjects_and_runs < matlab.unittest.TestCase
    properties
        fs;
    end
    methods(TestMethodSetup)
        function createFigure(testCase)
            path_to_test_case = fileparts(fileparts(mfilename('fullpath')));
            testCase.fs = NiftiFS([path_to_test_case filesep 'Test_Data' filesep 'example_data_Multiple_Runs' filesep 'example_data_Multiple_Runs']);
            assert(exist([path_to_test_case filesep 'Test_Data' filesep 'example_data_Multiple_Runs' filesep 'example_data_Multiple_Runs'], 'dir')>0)
            set_functional_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep '{runs}' filesep '{scans}']);
            set_subject_strmatch(testCase.fs, 's*');
            rm(testCase.fs, {'subject_masks'});
            set_run_strmatch(testCase.fs, '*');
        end
        function test_subjects(testCase)
            set_subjects(testCase.fs);
            rm(testCase.fs, {'subject_masks'});
            testCase.verifyEqual(size(testCase.fs.subject_array.get_subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subject_array.get_runs,1), 8);
        end
    end
    methods(Test)
        
        function test_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*.img');
            set_functional_scans(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.get_functional_scans,1), 214*8);
        end
        function test_get_scans(testCase)
            set_scan_strmatch(testCase.fs, 'fs*.img');
            scans = get_functional_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 214*8);
        end

    end
    
end