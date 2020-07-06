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
import DiverstRichTextInput from 'components/Shared/DiverstRichTextInput';
import GroupSelector from 'components/Shared/GroupSelector';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupFormInner({ classes, formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;
  const childrenSelectAction = (searchKey = '') => {
    props.getGroupsSuccess({ items: [] });
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: ['all_parents', 'no_children']
    });
  };

  const parentSelectAction = (searchKey = '') => {
    props.getGroupsSuccess({ items: [] });
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
                    label={<DiverstFormattedMessage {...messages.private} />}
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
          </CardContent>
          <CardContent>
            <Field
              component={DiverstRichTextInput}
              required
              onChange={value => setFieldValue('description', value)}
              fullWidth
              id='description'
              name='description'
              margin='normal'
              label={<DiverstFormattedMessage {...messages.description} />}
              value={values.description}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <GroupSelector
              groupField='child_ids'

              dialogSelector
              dialogNoChildren
              hardReload

              label={<DiverstFormattedMessage {...messages.children} />}
              isMulti
              disabled={props.isCommitting}
              queryScopes={['all_parents', 'no_children']}
              {...formikProps}
            />
          </CardContent>
          <Divider />
          <CardContent>
            <GroupSelector
              groupField='parent_id'

              dialogSelector
              dialogNoChildren
              hardReload

              label={<DiverstFormattedMessage {...messages.parent} />}
              disabled={props.isCommitting}
              queryScopes={['all_parents']}
              {...formikProps}
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
        if (values.child_ids == null)
          values.child_ids = [];
        props.groupAction(mapFields(values, ['child_ids', 'parent_id']));
      }}
    >
      {formikProps => <GroupFormInner {...props} formikProps={formikProps} />}
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
  formikProps: PropTypes.shape({
    handleSubmit: PropTypes.func,
    handleChange: PropTypes.func,
    handleBlur: PropTypes.func,
    values: PropTypes.object,
    setFieldValue: PropTypes.func,
    setFieldTouched: PropTypes.func,
  }),
  edit: PropTypes.bool,
  group: PropTypes.object,
  classes: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  getGroupsSuccess: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupForm);
