import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { FormControl, FormLabel, Box } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';
import useDelayedTextInputCallback from 'utils/customHooks/delayedTextInputCallback';

export function DiverstRichTextInput(props) {
  const { label, value, fullWidth, ...rest } = props;

  const wrapperStyle = {
    border: '1px solid lightgray',
    padding: '10px',
    borderRadius: '4px',
    width: '99%',
  };

  const [editorState, setEditorState] = useState(
    EditorState.createWithContent(
      ContentState.createFromBlockArray(
        htmlToDraft(value)
      )
    )
  );
  const [initialValue, setInitialValue] = useState(true);

  const setEditorStateFromValue = (value) => {
    setEditorState(EditorState.createWithContent(
      ContentState.createFromBlockArray(
        htmlToDraft(value)
      )
    ));
  };

  useEffect(() => {
    if (value !== '' && initialValue) {
      setEditorStateFromValue(value);
      if (initialValue)
        setInitialValue(false);
    }
  }, [value]);

  const delayedOnChange = useDelayedTextInputCallback(
    () => props.onChange(
      draftToHtml(convertToRaw(editorState.getCurrentContent()))
    )
  );

  const onEditorStateChange = (newEditorState) => {
    if (initialValue)
      setInitialValue(false);
    setEditorState(newEditorState);

    if (props.onChange)
      if (editorState.getCurrentContent().getPlainText().trim() !== '') {
        delayedOnChange();
      } else {
        props.onChange('');
      }
  };

  return (
    <FormControl {...rest}>
      <Box pt={2} />
      <FormLabel {...rest}>
        {label}
      </FormLabel>
      <Box mb={1} />
      <Editor
        editorState={editorState}
        onEditorStateChange={onEditorStateChange}
        wrapperStyle={wrapperStyle}
        editorStyle={{
          height: `${props.height}px`
        }}
      />
    </FormControl>
  );
}

DiverstRichTextInput.propTypes = {
  classes: PropTypes.object,
  onChange: PropTypes.func,
  value: PropTypes.string,
  height: PropTypes.number,
  fullWidth: PropTypes.bool,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
};

DiverstRichTextInput.defaultProps = {
  height: 200,
};

export default DiverstRichTextInput;
