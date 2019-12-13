/**
 *
 * Group Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';
import { Field, Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupFormInner({ classes, handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const childrenSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: ['all_parents', 'no_children']
    });
  };

  const parentSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      query_scopes: ['all_parents']
    });
  };

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.group}>
      <Card>
        <Form>
          <CardContent>
            <Grid container spacing={3}>
              <Grid item className={classes.noBottomPadding}>
                <FormControl
                  variant='outlined'
                  margin='normal'
                >
                  <FormControlLabel
                    labelPlacement='top'
                    checked={values.private}
                    control={(
                      <Field
                        component={Switch}
                        color='primary'
                        onChange={handleChange}
                        id='private'
                        name='private'
                        margin='normal'
                        disabled={props.isCommitting}
                        checked={values.private}
                        value={values.private}
                      />
                    )}
                    label='Private?'
                  />
                </FormControl>
              </Grid>
              <Grid item xs className={classes.noBottomPadding}>
                <Field
                  component={TextField}
                  required
                  onChange={handleChange}
                  fullWidth
                  id='name'
                  name='name'
                  margin='normal'
                  disabled={props.isCommitting}
                  label={<DiverstFormattedMessage {...messages.name} />}
                  value={values.name}
                />
              </Grid>
            </Grid>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              id='short_description'
              name='short_description'
              margin='normal'
              disabled={props.isCommitting}
              value={values.short_description}
              label={<DiverstFormattedMessage {...messages.short_description} />}
            />
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              id='description'
              name='description'
              multiline
              rows={4}
              variant='outlined'
              margin='normal'
              disabled={props.isCommitting}
              label={<DiverstFormattedMessage {...messages.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='child_ids'
              name='child_ids'
              label={<DiverstFormattedMessage {...messages.children} />}
              isMulti
              margin='normal'
              disabled={props.isCommitting}
              value={values.child_ids}
              options={props.selectGroups}
              onMenuOpen={childrenSelectAction}
              onChange={value => setFieldValue('child_ids', value)}
              onInputChange={value => childrenSelectAction(value)}
              onBlur={() => setFieldTouched('child_ids', true)}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <Field
              component={Select}
              fullWidth
              id='parent_id'
              name='parent_id'
              label={<DiverstFormattedMessage {...messages.parent} />}
              margin='normal'
              disabled={props.isCommitting}
              value={values.parent_id}
              options={props.selectGroups}
              onMenuOpen={parentSelectAction}
              onChange={value => setFieldValue('parent_id', value)}
              onInputChange={value => parentSelectAction(value)}
              onBlur={() => setFieldTouched('parent_id', true)}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={ROUTES.admin.manage.groups.index.path()}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function GroupForm(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    private: { default: false },
    name: { default: '' },
    short_description: { default: '' },
    description: { default: '' },
    parent: { default: '', customKey: 'parent_id' },
    children: { default: [], customKey: 'child_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <GroupFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupForm.propTypes = {
  edit: PropTypes.bool,
  groupAction: PropTypes.func,
  group: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

GroupFormInner.propTypes = {
  edit: PropTypes.bool,
  group: PropTypes.object,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupForm);
