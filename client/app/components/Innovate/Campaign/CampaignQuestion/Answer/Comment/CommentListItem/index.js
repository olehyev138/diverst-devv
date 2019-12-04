import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';


export function CommentListItem(props) {
  return (
    props.currentComment && (
      <React.Fragment>
        <Grid item xs={6}>
          <Card>
            <CardContent>
              <h3>
                {`${props.currentComment.author.first_name} ${props.currentComment.author.last_name} `}
                commented:
                {' '}
                {props.currentComment.content}
              </h3>
            </CardContent>
          </Card>
        </Grid>
      </React.Fragment>
    )
  );
}

CommentListItem.propTypes = {
  currentComment: PropTypes.object

};

export default compose(
  memo,
)(CommentListItem);
