/**
 *
 * Group Home Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Divider, Typography, Card, Button, CardContent, Link, Box, Tooltip } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { ROUTES } from 'containers/Shared/Routes/constants';
import GroupIcon from '@material-ui/icons/Group';
import GroupOutlinedIcon from '@material-ui/icons/GroupOutlined';
import Collapse from '@material-ui/core/Collapse';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import appMessages from 'containers/Shared/App/messages';

const styles = theme => ({
  groupName: {
    textAlign: 'left',
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
});

export function GroupHomeFamily({ classes, ...props }) {
  const renderGroup = group => (
    <Grid container spacing={1} justify='space-between'>
      <Grid item xs={10}>
        <Link
          component={WrappedNavLink}
          to={ROUTES.group.home.path(group.id)}
        >
          <Typography className={classes.groupName}>
            {`${group.name}`}
          </Typography>
        </Link>
      </Grid>
      <Grid item xs={2}>
        {group.current_user_is_member
          ? (
            <Tooltip title={<DiverstFormattedMessage {...messages.family.areMember} />} enterDelay={300} placement='right'>
              <GroupIcon />
            </Tooltip>
          ) : (
            <Tooltip title={<DiverstFormattedMessage {...messages.family.notMember} />} enterDelay={300} placement='right'>
              <GroupOutlinedIcon />
            </Tooltip>
          )}
      </Grid>
    </Grid>
  );

  // subgroups grouped by categories when subgroup is categorized for showing in group family card
  const categorizedSubGroups = props.currentGroup.children.reduce((newArray, item) => {
    if (item.group_category != null)
      (newArray[item.group_category.name] = newArray[item.group_category.name] || []).push(item);
    return newArray;
  }, {});

  return (props.currentGroup.parent || props.currentGroup.children.length > 0) && (
    <Card>
      <CardContent>
        {props.currentGroup.parent && (
          <React.Fragment>
            <Typography variant='h6'>
              <DiverstFormattedMessage {...appMessages.custom_text.parent} />
            </Typography>
            <Box mb={1} />
            <Divider />
            <Box mb={1} />
            { renderGroup(props.currentGroup.parent) }
          </React.Fragment>
        )}

        {props.currentGroup.children.length > 0
        && (
          <React.Fragment>
            <Typography variant='h6'>
              <DiverstFormattedMessage {...appMessages.custom_text.sub_erg} />
              (
              {props.currentGroup.children.length}
              )
            </Typography>
            {Object.keys(categorizedSubGroups).map(category => (
              <React.Fragment key={category}>
                <Box mb={1} />
                <Divider />
                <Box mb={1} />
                <Typography variant='h6' className={classes.groupName}>
                  {category}
                  (
                  {categorizedSubGroups[`${category}`].length}
                  )
                </Typography>
                {categorizedSubGroups[`${category}`].map(subgroup => (
                  <React.Fragment key={`subgroup:${subgroup.id}`}>
                    {renderGroup(subgroup)}
                  </React.Fragment>
                ))}
              </React.Fragment>
            ))
            }
            {props.currentGroup.children.map(child => (
              child.group_category == null
            && (
              <React.Fragment key={`child:${child.id}`}>
                <Box mb={1} />
                <Divider />
                <Box mb={1} />
                {renderGroup(child)}
              </React.Fragment>
            )
            ))}
          </React.Fragment>
        )
        }
      </CardContent>
    </Card>
  );
}

GroupHomeFamily.propTypes = {
  currentGroup: PropTypes.object,
  classes: PropTypes.object,
  joinGroup: PropTypes.func,
  leaveGroup: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupHomeFamily);