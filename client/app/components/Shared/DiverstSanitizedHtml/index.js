import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';
import sanitizeHtml from 'sanitize-html';

const styles = theme => ({
});

function DiverstSanitizedHtml(props) {
  const { html } = props;
  const sanitize = dirty => ({
    __html: sanitizeHtml(
      dirty,
      {
        allowedTags: ['b', 'i', 'em', 'strong', 'ul', 'ol', 'li', 'strike', 'ins', 'del', 'span'],
        allowedAttributes: { 'span': [ 'style' ] }
      }
    )
  });

  return (
    <React.Fragment>
      <Typography dangerouslySetInnerHTML={sanitize(html)} />
    </React.Fragment>
  );
}

DiverstSanitizedHtml.propTypes = {
  html: PropTypes.string,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstSanitizedHtml);
