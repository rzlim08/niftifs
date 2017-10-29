classdef test_soren_data < matlab.unittest.TestCase
    properties
        fs;
    end
    methods(TestMethodSetup)
        function createFigure(testCase)
            path_to_test_case = fileparts(fileparts(mfilename('fullpath')));
            testCase.fs = NiftiFS([path_to_test_case filesep 'Test_Data' filesep 'soren']);
            assert(exist([path_to_test_case filesep 'Test_Data' filesep 'soren'], 'dir')>0)
            set_functional_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep 'Unnamed*' filesep '{runs}' filesep '{scans}']);
            set_subject_strmatch(testCase.fs, 'Ca*');
            set_run_strmatch(testCase.fs, 'fMRI_S*');
            set_scan_strmatch(testCase.fs, '20*.nii');
            set_structural_dirstruct(testCase.fs, ['{top_level}' filesep '{subjects}' filesep 'Unnamed*' filesep 'Cor*' filesep 'co*.nii']);

        end
        function test_subjects(testCase)
            set_subjects(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.path_to_runs,1), 8);
        end
    end
    methods(Test)
        
        function test_scans(testCase)
            set_functional_scans(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.functional_scans,1), 345*8);
        end
        function test_get_scans(testCase)
            scans = get_functional_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 345*8);
        end
        function test_get_subjScans(testCase)
            scans = get_subj_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 4);
        end
        function test_structurals(testCase)
            scans = get_structural_scans(testCase.fs);
            testCase.verifyEqual(size(scans,1), 4);
        end
    end
    
end