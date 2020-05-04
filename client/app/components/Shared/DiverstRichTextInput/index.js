import React from 'react';
import PropTypes from 'prop-types';
import { Card } from '@material-ui/core';
import { EditorState, convertToRaw, ContentState } from 'draft-js';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import draftToHtml from 'draftjs-to-html';
import htmlToDraft from 'html-to-draftjs';

class DiverstRichTextInput extends React.PureComponent {
  constructor(props) {
    super(props);
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

    return (
      <React.Fragment>
        <Card style={{ height: 400 }}>
          <Editor
            editorState={editorState}
            onEditorStateChange={this.onEditorStateChange}
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
};

export default DiverstRichTextInput;
