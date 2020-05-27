import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Card, Typography, TextField } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';

export function DiverstRichTextInput(props) {
  const { label, value, ...rest } = props;

  const editorStyle = {
    border: '1px solid lightgray',
    padding: '10px',
    borderRadius: '4px',
    width: '100%',
  };

  const [editorState, setEditorState] = useState(
    EditorState.createWithContent(
      ContentState.createFromBlockArray(
        htmlToDraft(value)
      )
    )
  );

  const onEditorStateChange = (newEditorState) => {
    setEditorState(newEditorState);
    if (props.onChange)
      props.onChange(
        draftToHtml(convertToRaw(editorState.getCurrentContent()))
      );
  };

  return (
    <React.Fragment>
      <Typography variant='h6' color='primary'>
        {label}
      </Typography>
      <Editor
        editorState={editorState}
        onEditorStateChange={onEditorStateChange}
        editorStyle={editorStyle}
      />
    </React.Fragment>
  );
}

DiverstRichTextInput.propTypes = {
  classes: PropTypes.object,
  onChange: PropTypes.func,
  value: PropTypes.string,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
};

export default DiverstRichTextInput;
