import React from 'react';
import PropTypes from 'prop-types';
import { Card, Typography, TextField } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';

class DiverstRichTextInput extends React.PureComponent {
  constructor(props) {
    super(props);
    const { title } = this.props;
    const { html } = this.props;
    const contentBlock = htmlToDraft(html);
    if (contentBlock) {
      const contentState = ContentState.createFromBlockArray(contentBlock.contentBlocks);
      const editorState = EditorState.createWithContent(contentState);
      this.state = {
        editorState,
      };
    }
  }

  onEditorStateChange = (editorState) => {
    this.setState({
      editorState,
    });
    this.props.getRichTextHTML(draftToHtml(convertToRaw(editorState.getCurrentContent())));
  };

  render() {
    const { editorState } = this.state;
    const { title } = this.props;

    return (
      <React.Fragment>
        <Typography>
          {title}
        </Typography>
        <Card style={{ height: 300 }}>
          <Editor
            editorState={editorState}
            onEditorStateChange={this.onEditorStateChange}
            toolbar={{
              options: ['inline', 'fontSize', 'list'],
              inline: { options: ['bold', 'italic', 'underline', 'strikethrough'] },
            }}
          />
        </Card>
      </React.Fragment>
    );
  }
}

DiverstRichTextInput.propTypes = {
  classes: PropTypes.object,
  html: PropTypes.string,
  getRichTextHTML: PropTypes.func,
  title: PropTypes.string,
};

export default DiverstRichTextInput;
