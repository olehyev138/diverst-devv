import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Card, Typography, TextField, FormLabel } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';

export function DiverstRichTextInput(props) {
  const { label, value, ...rest } = props;

  const [editorState, setEditorState] = useState(
    EditorState.createWithContent(
      ContentState.createFromBlockArray(
        htmlToDraft(value)
      )
    )
  );
  const [iniValue, setIniValue] = useState(true);

  useEffect(() => {
    if (value != "" && iniValue)
    {
      setEditorState(EditorState.createWithContent(
        ContentState.createFromBlockArray(
          htmlToDraft(value)
        )
      ));
      setIniValue(false);
    }
  }, [value]);

  const onEditorStateChange = (newEditorState) => {
    setIniValue(false);
    setEditorState(newEditorState);
    if (props.onChange)
      props.onChange(
        draftToHtml(convertToRaw(editorState.getCurrentContent()))
      );
  };

  return (
    <React.Fragment>
      <FormLabel>
        {label}
      </FormLabel>
      <Editor
        editorState={editorState}
        onEditorStateChange={onEditorStateChange}
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
