import React, { memo, useState, useEffect } from 'react';
import { compose } from 'redux';
import { withStyles, withTheme, makeStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { FormControl, FormLabel, Box, CircularProgress, Grid } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';
import useDelayedTextInputCallback from 'utils/customHooks/delayedTextInputCallback';
import CheckCircleIcon from '@material-ui/icons/CheckCircle';

const wrapperStyle = {
  border: '1px solid lightgray',
  padding: 10,
  borderRadius: 4,
};

const getEditorStyle = (height, borderSize) => ({
  height,
  border: `${borderSize}px solid #F1F1F1`,
  borderRadius: 2,
  padding: 8,
  lineHeight: 1,
});

const useStyles = makeStyles({
  editorContainer: {
    '& .public-DraftEditor-content': {
      cursor: 'auto', // Use proper text cursor for input
    },
    '& .public-DraftStyleDefault-block': {
      margin: 0, // Remove top & bottom input margins
    },
    '& .DraftEditor-root': {
      // Compensate height for border size and vertical padding to prevent unnecessary scrollbar in editor
      height: props => props.height - 2 * (props.borderSize + 8),
    },
  },
});

const styles = theme => ({
  wrapper: {
    margin: theme.spacing(1),
    position: 'relative',
  },
  buttonProgress: {
    position: 'absolute',
    top: '90%',
    left: '90%',
    marginTop: -12,
    marginLeft: -12,
    zIndex: 5,
  }
});

export function DiverstRichTextInput(props) {
  const { classes, label, value, fullWidth, onChange, height, borderSize, field, form, ...rest } = props;

  const editorClasses = useStyles({ height, borderSize });

  const [editorStyle, setEditorStyle] = useState(getEditorStyle(height, borderSize));

  useEffect(() => {
    setEditorStyle(getEditorStyle(height, borderSize));
  }, [height, borderSize]);

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

  const [delayedOnChange, pendingChanges] = useDelayedTextInputCallback(
    (newState) => {
      const value = draftToHtml(convertToRaw(newState.getCurrentContent()));
      props.onChange(
        value
      );
    }
  );
    

  const onEditorStateChange = (newEditorState) => {
    if (initialValue)
      setInitialValue(false);
    setEditorState(newEditorState);

    if (props.onChange)
      if (editorState.getCurrentContent().getPlainText().trim() !== '') {
        delayedOnChange(newEditorState);
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
      <div className={classes.wrapper}>
        <Editor
          toolbar={{
            options: ['inline', 'blockType', 'fontSize', 'fontFamily', 'list', 'textAlign', 'colorPicker', 'link', 'remove', 'history']
          }}
          editorState={editorState}
          onEditorStateChange={onEditorStateChange}
          wrapperStyle={wrapperStyle}
          editorStyle={editorStyle}
          editorClassName={editorClasses.editorContainer}
        />
      </div>
      {pendingChanges() ? (
        <Grid container justify='center' alignContent='center'>
          <Grid item>
            <CircularProgress size={20} thickness={1.5} className={classes.buttonProgress} />
          </Grid>
        </Grid>
      ) : (
        <Grid container justify='center' alignContent='center'>
          <Grid item>
            <CheckCircleIcon className={classes.buttonProgress} color='primary' />
          </Grid>
        </Grid>
      )}
    </FormControl>
  );
}

DiverstRichTextInput.propTypes = {
  classes: PropTypes.object,
  onChange: PropTypes.func,
  value: PropTypes.string,
  height: PropTypes.number.isRequired,
  borderSize: PropTypes.number.isRequired,
  fullWidth: PropTypes.bool,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
  field: PropTypes.object,
  form: PropTypes.object,
};

DiverstRichTextInput.defaultProps = {
  height: 200,
  borderSize: 1,
};

export default compose(
  memo,
  withStyles(styles)
)(DiverstRichTextInput);
