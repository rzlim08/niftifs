classdef test_preprocessing12 < matlab.unittest.TestCase
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
        end
        
        function createPreprocessor(testCase)
            testCase.p =  Preprocessor12( ...
                [fileparts(mfilename('fullpath')) filesep 'test_output'], ...
                testCase.fs, ...
                '/home/cnoslab-ra/Applications/spm12');
            assert(~isempty(testCase.p));
        end
    end
    
    methods(Test)   
        function test_smoothing(testCase)
            p = testCase.p;
            batch = p.run_smoothing(p.get_matlabbatch('smoothing'));
            p.run_spmjobman(batch);
        end

        
        
    end
end

