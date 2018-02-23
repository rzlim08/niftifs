classdef test_subject_funs< matlab.unittest.TestCase
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
            testCase.verifyEqual(size(testCase.fs.subject_array.get_subjects,1), 4);
        end
        function test_runs(testCase)
            set_runs(testCase.fs);
            testCase.verifyEqual(size(testCase.fs.subject_array.get_runs,1), 8);
        end
    end
    methods(Test)
        
        function test_add_associated(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject.add_associated_matrix('G', rand(5));
            testCase.verifyTrue(isfield(Subject.associated_matrices, 'G'))
        end
        function test_get_associated(testCase)
            Subject = testCase.fs.subject_array.pop_subject;
            Subject.add_associated_matrix('G', rand(5));
            testCase.verifyTrue(isfield(Subject.associated_matrices, 'G'))
            testCase.verifyEqual(size(Subject.get_associated_matrix('G'),1), 5)
        end

    end
    
end