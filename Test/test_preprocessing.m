classdef test_preprocessing < matlab.unittest.TestCase
    %TEST_PREPROCESSING only works on BATMAN
    
    properties
        fs;
        p;
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
            set_subjects(testCase.fs);
            set_runs(testCase.fs);
            set_functional_scans(testCase.fs);
            set_structural_scans(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.functional_scans,1), 345*8);
        end
        
        function createPreprocessor(testCase)
            testCase.p =  Preprocessor( ...
                [fileparts(mfilename('fullpath')) filesep 'test_output'], ...
                testCase.fs, ...
                '/home/cnoslab-ra/Applications/spm12');
            assert(~isempty(testCase.p));
        end
    end
    
    methods(Test)
        function test_slice_timing(testCase)
            p = testCase.p;
            p.run_slice_timing(p.get_matlabbatch('slice_timing'), 2, get_slice_vector(p,40,1,1), 20);
        end
        function test_realignment(testCase)
            p = testCase.p;
            p.run_realignment(p.get_matlabbatch('realignment'));
        end
        function test_coregistration(testCase)
            p = testCase.p;
            p.run_coregistration(p.get_matlabbatch('coregistration'));
        end
        function test_segmentation(testCase)
            p = testCase.p;
            p.run_segmentation(p.get_matlabbatch('segmentation'));
        end
        function test_normalization(testCase)
            p = testCase.p;
            p.run_normalization(p.get_matlabbatch('normalization'));
        end
        function test_smoothing(testCase)
            p = testCase.p;
            p.run_smoothing(p.get_matlabbatch('smoothing'));
            
        end      
        function test_slice_timing_subset(testCase)
            p = testCase.p;
            subj_arr = testCase.fs.get_subject_array;
            subj_arr.remove('Careap101');
            p.run_slice_timing(p.get_matlabbatch('slice_timing'), ...
                2, get_slice_vector(p, 40,2,2), 20, subj_arr);
        end
        
        
    end
end

